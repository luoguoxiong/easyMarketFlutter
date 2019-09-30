/*
 * @Description: 商品详情页
 * @Author: luoguoxiong
 * @Date: 2019-08-26 16:41:58
 */

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_market/utils/rem.dart';
import 'package:easy_market/utils/cache.dart';
import 'package:easy_market/api/index.dart';
import 'package:easy_market/component/bottom_sheet.dart';
import 'package:easy_market/component/SliverCustomHeader.dart';
import 'package:easy_market/component/count.dart';
import 'package:easy_market/router/index.dart';
import 'package:flutter_html/flutter_html.dart';

class GoodsDetail extends StatefulWidget {
  GoodsDetail({this.arguments});
  final Map arguments;
  @override
  State<StatefulWidget> createState() {
    return _GoodsDetail();
  }
}

class _GoodsDetail extends State<GoodsDetail> {
  List imgList = [];

  bool initLoading = true;

  int goodsCount = 0; //购物车商品数量

  Map goodsMsgs;

  List chooseSizeIndex; // 当前所选的规格下标

  String chooseSizeStr; // 当前所选的规格名称

  Map goodsStockPrice; // 当前所选的规格商品信息(库存、价格等)

  int goodsNumber = 0; //商品数量

  int goodsMin = 0; //商品最少

  int goodsMax = 0; //商品最多

  String userToken; //用户token

  int userHasCollect; //用户是否收藏0：否；1：是

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  getInitData() async {
    int id = widget.arguments['id'];
    var sq = await SpUtil.getInstance();
    final token = sq.getString('token');
    List<Future> api = [
      Api.getGoodsMSG(id: id, token: token == null ? null : token)
    ];
    if (token != null) {
      api.add(
        Api.getCartMsg(token: token, id: id),
      );
    }
    var data = await Future.wait(api);
    var goodsMsg = data[0].data;
    var cartData = token != null ? data[1].data : null;

    var specificationList = goodsMsg['specificationList'];
    List<int> sizeIndex = [];
    List<String> sizeNameList = [];
    List<int> sizeId = [];
    for (var i = 0; i < specificationList.length; i++) {
      if (specificationList[i]['valueList'].length > 0) {
        sizeIndex.add(0);
        sizeId.add(specificationList[i]['valueList'][0]['id']);
        sizeNameList.add(specificationList[i]['valueList'][0]['value']);
      }
    }
    Map goodsStockPriceAny =
        getGoodsMsgById(goodsMsg['productList'], sizeId.join('_'));
    setState(() {
      imgList = goodsMsg['gallery'];
      goodsMsgs = goodsMsg;
      userHasCollect = goodsMsg['userHasCollect'];
      initLoading = false;
      goodsMax = goodsStockPriceAny['goods_number'];
      chooseSizeIndex = sizeIndex;
      chooseSizeStr = sizeNameList.join('、');
      goodsStockPrice = goodsStockPriceAny;
      userToken = token;
      goodsCount = token != null ? cartData['cartTotal']['goodsCount'] : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Color.fromARGB(1, 200, 200, 200),
              child: buildContent(context),
            ),
          ),
          buildFoot(context),
        ],
      ),
    );
  }

// 底部固定
  Widget buildFoot(BuildContext context) {
    return Container(
      height: Rem.getPxToRem(100),
      padding: EdgeInsets.symmetric(vertical: Rem.getPxToRem(10)),
      child: Row(
        children: <Widget>[
          InkResponse(
            child: Container(
              width: Rem.getPxToRem(100),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Icon(
                      userHasCollect == 1 ? Icons.star : Icons.star_border,
                      color: userHasCollect == 1 ? Colors.yellow : Colors.grey,
                      size: Rem.getPxToRem(50),
                    ),
                  ),
                  Center(
                    child: Text(
                      '收藏',
                      style: TextStyle(
                          color: Colors.grey, fontSize: Rem.getPxToRem(22)),
                    ),
                  )
                ],
              ),
            ),
            onTap: () async {
              if (userToken != null) {
                await Api.postAddCart(
                    id: widget.arguments['id'], token: userToken);
                setState(() {
                  userHasCollect = userHasCollect == 1 ? 0 : 1;
                });
              } else {
                Router.push('/login', context, null, () async {
                  var sq = await SpUtil.getInstance();
                  final token = sq.getString('token');
                  if (token != null) {
                    this.getInitData();
                  }
                });
              }
            },
          ),
          Container(
            width: Rem.getPxToRem(110),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.grey,
                          size: Rem.getPxToRem(50),
                        ),
                        userToken != null
                            ? Positioned(
                                top: 0,
                                right: Rem.getPxToRem(20),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.red),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    '$goodsCount',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: Rem.getPxToRem(20),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '购物车',
                    style: TextStyle(
                        color: Colors.grey, fontSize: Rem.getPxToRem(22)),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                Rem.getPxToRem(20),
                0,
                Rem.getPxToRem(10),
                0,
              ),
              child: Center(
                child: Container(
                  child: Center(
                    child: Text(
                      '加入购物车',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(
                      Radius.circular(Rem.getPxToRem(90)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                Rem.getPxToRem(10),
                0,
                Rem.getPxToRem(20),
                0,
              ),
              child: Center(
                child: Container(
                  child: Center(
                    child: Text(
                      '立即购买',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(
                      Radius.circular(Rem.getPxToRem(90)),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          new BoxShadow(
            color: Colors.grey[300],
            blurRadius: Rem.getPxToRem(1),
            spreadRadius: 0.2,
          )
        ],
      ),
    );
  }

// 核心
  Widget buildContent(BuildContext context) {
    if (initLoading) {
      return Center(
        child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(strokeWidth: 2.0)),
      );
    } else {
      return CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverCustomHeaderDelegate(
              title:
                  initLoading ? 'loading...' : '${goodsMsgs["info"]['name']}',
              collapsedHeight: Rem.getPxToRem(100),
              expandedHeight: Rem.getPxToRem(700),
              paddingTop: MediaQuery.of(context).padding.top,
              child: buildSwiper(context, imgList),
            ),
          ),
          buildOneWidget(
            buildGoodsLa(context),
          ),
          buildOneWidget(
            buildGoodsMsg(context),
          ),
          buildOneWidget(
            buildSize(context),
          ),
          buildOneWidget(
            buildComment(context),
          ),
          buildOneWidget(Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10),
                height: Rem.getPxToRem(100),
                color: Colors.white,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  '商品详情',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Html(
                data: goodsMsgs['info']['goods_desc']
                    .replaceAll('<p><br/></p>', ''),
              ),
            ],
          )),
        ],
      );
    }
  }

  // ListView只加载一个
  SliverList buildOneWidget(Widget widget) {
    return SliverList(
        delegate: new SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return widget;
      },
      childCount: 1,
    ));
  }

// 轮播图
  Widget buildSwiper(BuildContext context, List imgData) {
    if (imgData.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: Rem.getPxToRem(700),
        color: Colors.blue,
        child: Center(
          child: Text(
            '该商品还没有配置图片哦！',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Rem.getPxToRem(700),
      child: Swiper(
        itemCount: imgData.length,
        itemBuilder: (BuildContext context, int index) {
          return CachedNetworkImage(
            imageUrl: imgData[index]['img_url'],
            fit: BoxFit.cover,
          );
        },
        controller: SwiperController(),
        scrollDirection: Axis.horizontal,
        autoplay: true,
        autoplayDelay: 4000,
        onTap: (index) => print('点击了第$index'),
      ),
    );
  }

// 商品活动栏
  Widget buildGoodsLa(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 244, 244, 244),
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.red,
                      size: Rem.getPxToRem(26),
                    ),
                    Container(
                      child: Text(
                        '30天无忧退货',
                        style: TextStyle(fontSize: Rem.getPxToRem(26)),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.red,
                      size: Rem.getPxToRem(26),
                    ),
                    Text(
                      '满88元免邮费',
                      style: TextStyle(fontSize: Rem.getPxToRem(26)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.red,
                      size: Rem.getPxToRem(26),
                    ),
                    Text(
                      '48小时快速退款',
                      style: TextStyle(fontSize: Rem.getPxToRem(26)),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // 商品信息
  Widget buildGoodsMsg(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              goodsMsgs["info"]['name'],
              style: TextStyle(
                fontSize: Rem.getPxToRem(40),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              goodsMsgs["info"]['goods_brief'],
              style: TextStyle(
                color: Colors.grey,
                fontSize: Rem.getPxToRem(30),
              ),
            ),
          ),
          Text(
            '￥${goodsStockPrice['retail_price']}',
            style: TextStyle(
              color: Colors.red,
              fontSize: Rem.getPxToRem(40),
            ),
          ),
        ],
      ),
    );
  }

  // 选择规格
  Widget buildSize(BuildContext context) {
    return InkResponse(
      child: Container(
        height: Rem.getPxToRem(100),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                '已选',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${chooseSizeStr.length > 0 ? chooseSizeStr : '该商品没有size!'}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('x$goodsNumber'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        buildSizeModel(context);
      },
    );
  }

  // 商品评论
  Widget buildComment(BuildContext context) {
    List<Widget> imgs = [];
    if (goodsMsgs['comment']['count'] > 0) {
      var imgListMap = goodsMsgs['comment']['data']['pic_list'];
      for (int i = 0; i < imgListMap.length; i++) {
        imgs.add(Container(
          height: Rem.getPxToRem(200),
          width: Rem.getPxToRem(200),
          child: CachedNetworkImage(
            imageUrl: imgListMap[i]['pic_url'],
            fit: BoxFit.cover,
          ),
        ));
      }
    }
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          InkResponse(
            child: Container(
              height: Rem.getPxToRem(100),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      '评论',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        '${goodsMsgs['comment']['count']}条',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              if (goodsMsgs['comment']['count'] > 0) {
                Router.push(
                    '/moreComment', context, {'id': widget.arguments['id']});
              }
            },
          ),
          goodsMsgs['comment']['count'] > 0
              ? Container(
                  height: Rem.getPxToRem(80),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey,
                        width: .5,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('匿名用户'),
                      ),
                      Text(
                        '${goodsMsgs['comment']['data']['add_time']}',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          goodsMsgs['comment']['count'] > 0
              ? Container(
                  height: Rem.getPxToRem(80),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    '${goodsMsgs['comment']['data']['content']}',
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                )
              : Container(),
          goodsMsgs['comment']['count'] > 0
              ? Container(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                  width: double.infinity,
                  child: Wrap(
                    children: imgs,
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  // 商品规格弹窗
  buildSizeModel(BuildContext context) {
    return showModalBottomSheetOp(
      backgroundColor: Colors.transparent,
      context: context,
      // 这里不知道为什么会重复执行TODO优化
      // 因为动画问题
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context1, setstate1) {
          return Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                // close按钮
                Align(
                  alignment: Alignment.centerRight,
                  child: InkResponse(
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                // 商品图片
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 100,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              child: CachedNetworkImage(
                                imageUrl: goodsMsgs['info']['list_pic_url'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 75,
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "￥",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${goodsStockPrice['retail_price']}',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 25,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${chooseSizeStr.length > 0 ? chooseSizeStr : goodsMsgs["info"]['name']}',
                                            style:
                                                TextStyle(color: Colors.grey),
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //商品规格
                buildSizeItem(context, setstate1),
                // 商品数量
                buildSizeNun(context, setstate1),
                // 下单或加入购物车
                Container(
                  height: Rem.getPxToRem(80),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                            Rem.getPxToRem(20),
                            0,
                            Rem.getPxToRem(10),
                            0,
                          ),
                          child: Center(
                            child: Container(
                              child: Center(
                                child: Text(
                                  '加入购物车',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Rem.getPxToRem(80)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                            Rem.getPxToRem(10),
                            0,
                            Rem.getPxToRem(20),
                            0,
                          ),
                          child: Center(
                            child: Container(
                              child: Center(
                                child: Text(
                                  '立即购买',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Rem.getPxToRem(80)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  Widget buildSizeNun(BuildContext context, setstate1) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 5, 10),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Text(
              '数量',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Count(
                number: goodsNumber,
                min: goodsMin,
                max: goodsMax,
                onChange: (index) {
                  setstate1(() {
                    goodsNumber = index;
                  });
                  setState(() {
                    goodsNumber = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 规格选择器
  Widget buildSizeItem(BuildContext context, setstate1) {
    var specificationList = goodsMsgs['specificationList'];
    List<Widget> list = [];
    for (var i = 0; i < specificationList.length; i++) {
      List<Widget> sizeItemList = [];
      for (var j = 0; j < specificationList[i]['valueList'].length; j++) {
        if (j == chooseSizeIndex[i]) {
          sizeItemList.add(
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: Color.fromARGB(10, 240, 10, 32),
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: Text(
                specificationList[i]['valueList'][j]['value'],
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        } else {
          sizeItemList.add(InkResponse(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey[200]),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: Text(specificationList[i]['valueList'][j]['value']),
            ),
            onTap: () {
              chooseSizeIndex[i] = j;
              setstate1(() {});
              Map data = getSizeMsgByIndex(chooseSizeIndex);
              setState(() {
                chooseSizeIndex = chooseSizeIndex;
                chooseSizeStr = data['chooseSizeStr'];
                goodsNumber = 0;
                goodsMax = data['goodsStockPrice']['goods_number'];
                goodsStockPrice = data['goodsStockPrice'];
              });
            },
          ));
        }
      }
      list.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                margin: EdgeInsets.only(bottom: 5),
                child: Text(
                  specificationList[i]['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: double.infinity,
                child: Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  children: sizeItemList,
                ),
              )
            ],
          ),
        ),
      );
    }
    return Column(
      children: list,
    );
  }

  // 通过下标获取商品的价格跟规格名称
  getSizeMsgByIndex(chooseSizeIndex) {
    var specificationList = goodsMsgs['specificationList'];
    List sizeStrList = [];
    List sizeIdList = [];
    for (var i = 0; i < specificationList.length; i++) {
      for (var j = 0; j < specificationList[i]['valueList'].length; j++) {
        if (chooseSizeIndex[i] == j) {
          sizeStrList.add(specificationList[i]['valueList'][j]['value']);
          sizeIdList.add(specificationList[i]['valueList'][j]['id']);
          break;
        }
      }
    }
    Map goodsStockAndPrice =
        getGoodsMsgById(goodsMsgs['productList'], sizeIdList.join('_'));
    return {
      'chooseSizeStr': sizeStrList.join('、'),
      'goodsStockPrice': goodsStockAndPrice,
    };
  }

  // 获取某规格的商品信息
  getGoodsMsgById(List productList, String id) {
    for (int i = 0; i < productList.length; i++) {
      if (productList[i]['goods_specification_ids'] == id) {
        return productList[i];
      }
    }
  }
}

/*
 * @Description: 商品详情页
 * @Author: luoguoxiong
 * @Date: 2019-08-26 16:41:58
 */

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:easy_market/model/index.dart';
import 'package:easy_market/utils/rem.dart';
import 'package:easy_market/api/index.dart';

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

  int goodsCount = 0;

  Map goodsMsgs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getInitData();
  }

  getInitData() async {
    int id = widget.arguments['id'];
    final model = Provider.of<Model>(this.context);
    if (model.token != null) {
      var data = await Future.wait([
        Api.getGoodsMSG(id: id),
        Api.getCartMsg(token: model.token, id: id),
      ]);
      var goodsMsg = data[0].data;
      var cartData = data[1].data;
      setState(() {
        imgList = goodsMsg['gallery'];
        goodsMsgs = goodsMsg;
        initLoading = false;
        goodsCount = cartData['cartTotal']['goodsCount'];
      });
    } else {
      var data = await Future.wait([
        Api.getGoodsMSG(id: id),
      ]);
      var goodsMsg = data[0].data;
      setState(() {
        imgList = goodsMsg['gallery'];
        goodsMsgs = goodsMsg;
        initLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: buildAppBar(
            initLoading ? 'loading...' : '${goodsMsgs["info"]['name']}'),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Color.fromARGB(1, 200, 200, 200),
                child: buildContent(context),
              ),
            ),
            buildFoot(context),
          ],
        ));
  }

// 导航栏
  Widget buildAppBar(title) {
    var paddingTop = MediaQuery.of(context).padding.top;
    return new PreferredSize(
      child: new Container(
        child: Row(
          children: <Widget>[
            InkResponse(
              child: Container(
                width: Rem.getPxToRem(100),
                child: Center(
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.black,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Center(
                child: Text(
                  '$title',
                  style: TextStyle(
                      color: Colors.black, fontSize: Rem.getPxToRem(38)),
                ),
              ),
            ),
            Container(
              width: Rem.getPxToRem(100),
            ),
          ],
        ),
        padding: new EdgeInsets.only(top: paddingTop),
        height: Rem.getPxToRem(100) + paddingTop,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
              color: Colors.grey[200],
              blurRadius: Rem.getPxToRem(1),
              spreadRadius: 0.1,
            )
          ],
        ),
      ),
      preferredSize: new Size(
          MediaQuery.of(context).size.width, Rem.getPxToRem(100) + paddingTop),
    );
  }

// 底部固定
  Widget buildFoot(BuildContext context) {
    return Container(
      height: Rem.getPxToRem(110),
      padding: EdgeInsets.symmetric(vertical: Rem.getPxToRem(10)),
      child: Row(
        children: <Widget>[
          Container(
            width: Rem.getPxToRem(110),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Icon(
                    Icons.star,
                    color: Colors.yellow,
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
          Container(
            width: Rem.getPxToRem(110),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add_shopping_cart,
                        color: Colors.grey,
                        size: Rem.getPxToRem(50),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          color: Colors.white,
                          child: Text(
                            '$goodsCount',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          padding: EdgeInsets.all(1),
                        ),
                      )
                    ],
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
            color: Colors.grey[200],
            blurRadius: Rem.getPxToRem(1),
            spreadRadius: 0.1,
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
          buildOneWidget(
            buildSwiper(context, imgList),
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
        pagination: SwiperPagination(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            builder: DotSwiperPaginationBuilder(
                color: Colors.grey[200],
                size: 8,
                activeColor: Colors.grey[400])),
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
    print(goodsMsgs['info']);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              goodsMsgs["info"]['name'],
              style: TextStyle(
                fontSize: Rem.getPxToRem(40),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              goodsMsgs["info"]['goods_brief'],
              style: TextStyle(
                color: Colors.grey,
                fontSize: Rem.getPxToRem(30),
              ),
            ),
          ),
          Text(
            '￥499',
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
    return Container(
      height: Rem.getPxToRem(100),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: .5,
          ),
        ),
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
                        '1.5m床垫*1+枕头*2、浅杏粉1.5m',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('x1'),
                  ],
                )),
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
    );
  }
}

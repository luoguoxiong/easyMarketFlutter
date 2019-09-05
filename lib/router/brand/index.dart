/*
 * @Description: 制造商详情页
 * @Author: luoguoxiong
 * @Date: 2019-08-26 15:59:04
 */
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_market/component/linearBar.dart';
import 'package:easy_market/utils/rem.dart';
import 'package:easy_market/api/index.dart';
import 'package:easy_market/router/index.dart';

class Brand extends StatefulWidget {
  Brand({this.arguments});
  final Map arguments;
  @override
  State<StatefulWidget> createState() {
    return _Brand();
  }
}

class _Brand extends State<Brand> {
  bool isLoading = true; // 第一次加载

  int total = 0; // 商品总是

  int page = 1; // 当前页数

  int size = 6; // 每页的商品数

  Map brandMsg; // 制造商信息

  List brandGoods; // 制造商商品

  bool moreLoading = false; // 是否加载更多

  ScrollController _scrollController = new ScrollController();

// 初始化信息
  void getInitGoods() async {
    var data = await Future.wait([
      Api.getBrandGoods(
          brandId: widget.arguments['id'], page: page, size: size),
      Api.getBrandMsg(id: widget.arguments['id'])
    ]);
    setState(() {
      isLoading = false;
      total = data[0].data['count'];
      brandGoods = data[0].data['data'];
      brandMsg = data[1].data['brand'];
    });
  }

// 获取更多制造商商品
  void getMoreBrandGoods() async {
    setState(() {
      moreLoading = true;
    });
    Future.delayed(Duration(seconds: 1)).then((e) async {
      var data = await Api.getBrandGoods(
          brandId: widget.arguments['id'], page: page + 1, size: size);
      brandGoods.insertAll(brandGoods.length, data.data['data']);
      setState(() {
        total = data.data['count'];
        page = page + 1;
        moreLoading = false;
      });
    });
  }

// 制造商logo
  Widget buildBrandLogo() {
    return Container(
      width: double.infinity,
      height: Rem.getPxToRem(400),
      child: CachedNetworkImage(
        imageUrl: brandMsg['list_pic_url'],
        fit: BoxFit.cover,
      ),
    );
  }

// 制造商描述
  Widget buildBrandDes() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(Rem.getPxToRem(20)),
        child: Center(
          child: Text(
            '        ${(brandMsg["simple_desc"]).replaceAll('\n', '')}',
            style: TextStyle(
                height: 1.2, color: Colors.grey, fontSize: Rem.getPxToRem(30)),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    getInitGoods();
    _scrollController.addListener(() {
      // 如果下拉的当前位置到scroll的最下面
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!moreLoading && (total > brandGoods.length)) {
          getMoreBrandGoods();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

// 加载更多
  Widget buildMore() {
    if (brandGoods.length == total) {
      return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
          child: Text(
            "没有更多商品!",
            style: TextStyle(color: Colors.grey),
          ));
    } else {
      return Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(strokeWidth: 2.0)),
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

// 商品
  SliverPadding buildBrandGoods() {
    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: new SliverGrid(
        //Grid
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //Grid按两列显示
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.8,
        ),
        delegate: new SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            //创建子widget
            Widget widget = new Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0))),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: brandGoods[index]['list_pic_url'],
                    ),
                  ),
                  Container(
                    height: Rem.getPxToRem(50),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Text(
                        '${brandGoods[index]['name']}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey, fontSize: Rem.getPxToRem(28)),
                      ),
                    ),
                  ),
                  Container(
                    height: Rem.getPxToRem(50),
                    child: Center(
                      child: Text(
                        '￥${brandGoods[index]['retail_price']}',
                        style: TextStyle(
                            color: Colors.red, fontSize: Rem.getPxToRem(30)),
                      ),
                    ),
                  ),
                ],
              ),
            );
            return Router.link(widget, '/goodsDetail', context,
                {'id': brandGoods[index]['id']});
          },
          childCount: brandGoods.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Material(
        child: SafeArea(
          child: Center(
            child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0)),
          ),
        ),
      );
    } else {
      return LinearBar(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            buildOneWidget(buildBrandLogo()),
            buildOneWidget(buildBrandDes()),
            buildBrandGoods(),
            buildOneWidget(buildMore()),
          ],
        ),
        removePadding: true,
        title: brandMsg['name'],
        appBarColor: Colors.green,
      );
    }
  }
}

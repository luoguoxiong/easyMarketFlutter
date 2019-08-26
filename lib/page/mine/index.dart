/*
 * @Description: 我的页
 * @Author: luoguoxiong
 * @Date: 2019-08-15 10:08:01
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_market/utils/rem.dart';

class Mine extends StatelessWidget {
  final List<Map<String, dynamic>> gridList = [
    {'name': '我的收藏', 'icon': 'assets/images/collect.png'},
    {'name': '地址管理', 'icon': 'assets/images/address.png'},
    {'name': '我的订单', 'icon': 'assets/images/order.png'},
    {'name': '周末拼单', 'icon': 'assets/images/week.png'},
    {'name': '优惠券', 'icon': 'assets/images/oppen.png'},
    {'name': '优选购', 'icon': 'assets/images/good.png'},
    {'name': '我的红包', 'icon': 'assets/images/hongbao.png'},
    {'name': '客服咨询', 'icon': 'assets/images/kefu.png'},
    {'name': '会员plus', 'icon': 'assets/images/huiyuan.png'},
    {'name': '意见反馈', 'icon': 'assets/images/issure.png'},
    {'name': '账户安全', 'icon': 'assets/images/safe.png'},
    {'name': '退出登录', 'icon': 'assets/images/logout.png'}
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          buildHeader(),
          buildItem(),
        ],
      ),
    );
  }

// 製造商
  SliverGrid buildItem() {
    return SliverGrid(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: 1,
      ),
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Container(
                height: Rem.getPxToRem(120),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: Rem.getPxToRem(60),
                      child: Image.asset(
                        gridList[index]['icon'],
                        width: Rem.getPxToRem(60),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Text(
                            gridList[index]['name'],
                            style: TextStyle(fontSize: Rem.getPxToRem(24)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        childCount: gridList.length,
      ),
    );
  }

  SliverList buildHeader() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          height: Rem.getPxToRem(300),
          child: Stack(
            children: <Widget>[
              Positioned(
                right: 0,
                left: 0,
                top: 0,
                bottom: 0,
                child: CachedNetworkImage(
                  imageUrl:
                      'http://yanxuan.nosdn.127.net/d069279e5834bbca17065a9855a014bf.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: Rem.getPxToRem(60),
                left: Rem.getPxToRem(50),
                child: Container(
                  width: Rem.getPxToRem(180),
                  height: Rem.getPxToRem(180),
                  decoration: BoxDecoration(
                    image: new DecorationImage(
                      image: new NetworkImage(
                          'http://yanxuan.nosdn.127.net/8945ae63d940cc42406c3f67019c5cb6.png'),
                      centerSlice:
                          new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
                    ),
                    borderRadius: BorderRadius.all(new Radius.circular(
                      Rem.getPxToRem(180),
                    )),
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  child: Center(
                    child: Text(
                      '15323807318',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  height: Rem.getPxToRem(80),
                ),
                top: Rem.getPxToRem(80),
                left: Rem.getPxToRem(260),
              ),
              Positioned(
                child: Container(
                  child: Center(
                    child: Text(
                      '普通用户',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  height: Rem.getPxToRem(80),
                ),
                top: Rem.getPxToRem(130),
                left: Rem.getPxToRem(260),
              )
            ],
          ),
        );
      }, childCount: 1),
    );
  }
}

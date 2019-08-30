/*
 * @Description: 制造商详情页
 * @Author: luoguoxiong
 * @Date: 2019-08-26 15:59:04
 */
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_market/component/linearBar.dart';
import 'package:easy_market/utils/rem.dart';

class Brand extends StatefulWidget {
  Brand({this.arguments});
  final Map arguments;
  @override
  State<StatefulWidget> createState() {
    return _Brand();
  }
}

class _Brand extends State<Brand> {
  Widget buildBrandLogo() {
    return Container(
      width: double.infinity,
      height: Rem.getPxToRem(400),
      child: CachedNetworkImage(
        imageUrl:
            'http://yanxuan.nosdn.127.net/1541445967645114dd75f6b0edc4762d.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildBrandDes() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(Rem.getPxToRem(20)),
      child: Text(
        '        严选精选了MUJI制造商和生产原料,用几乎零利润的价格，剔除品牌溢价，让用户享受原品牌的品质生活。',
        style: TextStyle(
            height: 1.2, color: Colors.grey, fontSize: Rem.getPxToRem(30)),
      ),
    );
  }

  Widget buildBrandGoods() {
    return null;
  }

  Widget buildGoodsList() {
    return Container(
      height: 1000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LinearBar(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              buildBrandLogo(),
              buildBrandDes(),
              buildGoodsList()
            ],
          ),
        ),
      ),
      removePadding: true,
      title: 'Coach制造商',
      appBarColor: Colors.green,
    );
  }
}

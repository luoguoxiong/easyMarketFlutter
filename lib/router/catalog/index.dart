/*
 * @Description: 商品分类页
 * @Author: luoguoxiong
 * @Date: 2019-08-26 15:59:04
 */
import 'package:flutter/material.dart';

class Catalog extends StatefulWidget {
  Catalog({this.arguments});
  final Map arguments;
  @override
  State<StatefulWidget> createState() {
    return _Catalog();
  }
}

class _Catalog extends State<Catalog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text('当前id是${widget.arguments['id']},\n当前页面尚未开发，请耐心等候！'),
      ),
    );
  }
}

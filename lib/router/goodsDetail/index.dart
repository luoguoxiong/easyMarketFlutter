/*
 * @Description: 商品详情页
 * @Author: luoguoxiong
 * @Date: 2019-08-26 16:41:58
 */

import 'package:flutter/material.dart';

class GoodsDetail extends StatefulWidget {
  GoodsDetail({this.arguments});
  final Map arguments;
  @override
  State<StatefulWidget> createState() {
    return _GoodsDetail();
  }
}

class _GoodsDetail extends State<GoodsDetail> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text('当前id是${widget.arguments['id']},\n当前页面尚未开发，请耐心等候！'),
      ),
    );
  }
}

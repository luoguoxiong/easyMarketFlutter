/*
 * @Description: 制造商详情页
 * @Author: luoguoxiong
 * @Date: 2019-08-26 15:59:04
 */
import 'package:flutter/material.dart';

class Brand extends StatefulWidget {
  Brand({this.arguments});
  final Map arguments;
  @override
  State<StatefulWidget> createState() {
    return _Brand();
  }
}

class _Brand extends State<Brand> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text('当前制造商id是${widget.arguments['id']},\n当前页面尚未开发，请耐心等候！'),
      ),
    );
  }
}

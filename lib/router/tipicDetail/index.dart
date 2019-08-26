/*
 * @Description: 专题详情页
 * @Author: luoguoxiong
 * @Date: 2019-08-26 16:41:58
 */

import 'package:flutter/material.dart';

class TopicDetail extends StatefulWidget {
  TopicDetail({this.arguments});
  final Map arguments;
  @override
  State<StatefulWidget> createState() {
    return _TopicDetail();
  }
}

class _TopicDetail extends State<TopicDetail> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text('当前id是${widget.arguments['id']},\n当前页面尚未开发，请耐心等候！'),
      ),
    );
  }
}

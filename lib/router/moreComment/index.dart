/*
 * @Description: 写评论
 * @Author: luoguoxiong
 * @Date: 2019-09-05 17:16:00
 */

import 'package:flutter/material.dart';

class MoreComment extends StatefulWidget {
  MoreComment({this.arguments});
  final Map arguments;
  @override
  State<StatefulWidget> createState() {
    return _MoreComment();
  }
}

class _MoreComment extends State<MoreComment> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text('更多评论！'),
      ),
    );
  }
}

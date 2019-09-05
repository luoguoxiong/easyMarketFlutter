/*
 * @Description: 写评论
 * @Author: luoguoxiong
 * @Date: 2019-09-05 17:16:00
 */

import 'package:flutter/material.dart';

class WriteComment extends StatefulWidget {
  WriteComment({this.arguments});
  final Map arguments;
  @override
  State<StatefulWidget> createState() {
    return _WriteComment();
  }
}

class _WriteComment extends State<WriteComment> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text('写评论'),
      ),
    );
  }
}

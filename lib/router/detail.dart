import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // 进行Named页面跳转 传递参数
          Navigator.pop(context, '/page');
        },
        child: Text("返回"),
      ),
    );
  }
}

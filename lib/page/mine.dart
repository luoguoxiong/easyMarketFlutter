import 'package:flutter/material.dart';

class Mine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // 进行Named页面跳转 传递参数
          Navigator.pushNamed(context, '/page', arguments: {'id': 126});
        },
        child: Text("我的页"),
      ),
    );
  }
}

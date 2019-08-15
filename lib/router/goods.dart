import 'package:flutter/material.dart';

class Goods extends StatelessWidget {
  Goods({this.arguments});
  final Map arguments;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text(
            "hi this is next page, id is ${arguments != null ? arguments['id'] : '0'}"),
      ),
    );
  }
}

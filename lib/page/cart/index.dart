import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_market/model/index.dart';

class Cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Cart();
  }
}

class _Cart extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);
    return Center(
      child: model.token != null ? Text('${model.token}') : Text('未登录'),
    );
  }
}

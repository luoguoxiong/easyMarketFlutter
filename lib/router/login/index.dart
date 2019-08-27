import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_market/model/index.dart';
import 'package:easy_market/router/index.dart';
import 'package:easy_market/utils/cache.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxNiwiaWF0IjoxNTY2NTQxMTc2fQ.zz6aYk3hh9UrELj-DeBGI5b29qkuz5do5RbwsN_m80U';
  void login(context) async {
    var sq = await SpUtil.getInstance();
    sq.putString('token', token);
    final model = Provider.of<Model>(context);
    model.setToken(token);
    Router.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
      child: InkResponse(
        child: Text('点击登录！'),
        onTap: () {
          login(context);
        },
      ),
    ));
  }
}

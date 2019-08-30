import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_market/model/index.dart';
import 'package:easy_market/router/index.dart';
import 'package:easy_market/utils/cache.dart';
import 'package:easy_market/api/index.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  void login(context) async {
    final sq = await SpUtil.getInstance();
    final model = Provider.of<Model>(context);
    var data = await Api.loginByMobile(
        mobile: _unameController.text, password: _pwdController.text);
    sq.putString('token', data.data['sessionKey']);
    sq.putString('userName', data.data['mobile']);
    model.setToken(data.data['sessionKey']);
    model.setUserName(data.data['mobile']);
    Router.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _unameController.text = "15323807318";
    _pwdController.text = "123456";
  }

  @override
  Widget build(BuildContext context) {
    //  child: InkResponse(
    //     child: Text('点击登录！'),
    //     onTap: () {
    //       login(context);
    //     },
    //   ),
    return Material(
        child: SafeArea(
            child: Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(50, 100, 50, 40),
          child: CachedNetworkImage(
            imageUrl:
                'http://yanxuan.nosdn.127.net/bd139d2c42205f749cd4ab78fa3d6c60.png',
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Form(
              key: _formKey, //设置globalKey，用于后面获取FormState
              autovalidate: true, //开启自动校验
              child: Column(
                children: <Widget>[
                  TextFormField(
                      controller: _unameController,
                      decoration: InputDecoration(
                          labelText: "手机号码",
                          hintText: "请输入您的手机号码",
                          icon: Icon(Icons.person)),
                      // 校验用户名
                      validator: (v) {
                        if (v.trim().length == 0) {
                          return '手机号码不能为空';
                        } else if (v != '15323807318') {
                          return '测试的账号15323807318！';
                        } else {
                          return null;
                        }
                      }),
                  TextFormField(
                      controller: _pwdController,
                      decoration: InputDecoration(
                          labelText: "密码",
                          hintText: "您的登录密码",
                          icon: Icon(Icons.lock)),
                      obscureText: true,
                      //校验密码
                      validator: (v) {
                        if (v.trim().length == 0) {
                          return '登录密码不能为空';
                        } else if (v != '123456') {
                          return '测试的登录密码时123456！';
                        } else {
                          return null;
                        }
                      }),
                  // 登录按钮
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.all(15.0),
                            child: Text("登录"),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              if ((_formKey.currentState as FormState)
                                  .validate()) {
                                login(context);
                                //验证通过提交数据
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    )));
  }
}

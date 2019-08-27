import 'package:flutter/material.dart';

class Model with ChangeNotifier {
  Model(this._token);

  String _token; // 用户token的值来区分是否登录(null?token)

  String get token => _token;

  void setToken(token) {
    _token = token;
    notifyListeners();
  }
}

/*
 * @Description: Provider数据管理
 * @Author: luoguoxiong
 * @Date: 2019-08-27 15:34:15
 */
import 'package:flutter/material.dart';

class Model with ChangeNotifier {
  Model(this._token, this._userName);

  String _token; // 用户token的值来区分是否登录(null?token)

  String _userName;

  String get token => _token;

  String get userName => _userName;

  void setToken(token) {
    _token = token;
    notifyListeners();
  }

  void setUserName(name) {
    _userName = name;
    notifyListeners();
  }
}

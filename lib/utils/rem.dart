/*
 * @Description: Rem适配
 * @Author: luoguoxiong
 * @Date: 2019-08-26 17:29:18
 */
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class Rem {
  static double _designWidth = 750.0;
  static bool _isInit = false;

  static double getPxToRem(val) {
    return MediaQueryData.fromWindow(ui.window).size.width * val / _designWidth;
  }

  static double getRemToPx(val) {
    return val * _designWidth / MediaQueryData.fromWindow(ui.window).size.width;
  }

  static setDesignWidth(val) {
    if (!_isInit) {
      _designWidth = val;
      _isInit = true;
    } else {
      // print('is init!!');
    }
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_market/Advertisement/openAd.dart';
import './app.dart';
// import 'package:easy_market/utils/rem.dart';

class Page extends StatefulWidget {
  _Page createState() => _Page();
}

class _Page extends State<Page> {
  // 是否启用广告
  bool showAd = true;
  // 广告展示时间
  int _seconds = 5;

  Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  // 启动倒计时的计时器。
  void _startTimer() {
    if (showAd) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {});
        if (_seconds <= 1) {
          setState(() {
            showAd = false;
          });
          _cancelTimer();
          return;
        } else {
          setState(() {
            _seconds = _seconds - 1;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  // 清除倒计时的计时器。
  void _cancelTimer() {
    _timer?.cancel();
  }

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // 显示app
        Offstage(
          child: App(),
          offstage: showAd,
        ),
        // 显示广告
        Offstage(
          child: OpenAd(_seconds),
          offstage: !showAd,
        ),
      ],
    );
  }
}

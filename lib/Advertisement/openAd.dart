import 'package:flutter/material.dart';

class OpenAd extends StatelessWidget {
  OpenAd(this.time);
  final int time;
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/timg.jpg'),
        fit: BoxFit.cover,
      )),
      // child: new Center(
      //   child: Text('$time'),
      // ),
    );
  }
}

import 'package:flutter/material.dart';

class OpenAd extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/openAd.jpg'),
        fit: BoxFit.cover,
      )),
    );
  }
}

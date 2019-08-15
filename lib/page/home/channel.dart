import 'package:flutter/material.dart';
import 'package:easy_market/utils/rem.dart';

class Channel extends StatelessWidget {
  final List data;
  Channel(this.data);
  Widget build(BuildContext context) {
    List<Widget> channel = [];
    data.forEach((item) => channel.add(
          Expanded(
              child: TopicItem(item['icon_url'], item['name'], item['id'])),
        ));
    return new Container(
      height: Rem.getPxToRem(120),
      color: Colors.white,
      child: new Row(children: channel),
    );
  }
}

class TopicItem extends StatelessWidget {
  final String url;
  final String name;
  final int id;
  TopicItem(this.url, this.name, this.id);
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          height: Rem.getPxToRem(80),
          padding: EdgeInsets.only(
              bottom: Rem.getPxToRem(4),
              left: Rem.getPxToRem(25),
              top: Rem.getPxToRem(25),
              right: Rem.getPxToRem(25)),
          child: Center(
            child: Image.network(
              url,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        new Container(
          height: Rem.getPxToRem(40),
          child: Center(
            child: new Text(
              name,
              style: TextStyle(
                fontSize: Rem.getPxToRem(20),
              ),
            ),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:easy_market/utils/rem.dart';

class News extends StatelessWidget {
  final List data;
  News(this.data);
  final title = '新品首发';
  Widget newsItem(msg) {
    return Container(
      width: Rem.getPxToRem(375),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Rem.getPxToRem(20)),
            child: Image.network(
              msg["list_pic_url"],
              height: Rem.getPxToRem(300),
              width: double.infinity,
            ),
          ),
          Center(
            child: Text(
              '${msg['name']}',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: Rem.getPxToRem(30)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: Rem.getPxToRem(5)),
            child: Text(
              '￥${msg['retail_price']}',
              style: TextStyle(color: Colors.red, fontSize: Rem.getPxToRem(28)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> news = [];
    data.forEach((item) => news.add(
          newsItem(item),
        ));
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: Rem.getPxToRem(20)),
      child: Column(
        children: <Widget>[
          Container(
            height: Rem.getPxToRem(100),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey[300], width: .5))),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    wordSpacing: 2,
                    fontSize: Rem.getPxToRem(30)),
              ),
            ),
          ),
          Wrap(
            children: news,
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:easy_market/utils/rem.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Hot extends StatelessWidget {
  final List data;
  Hot(this.data);
  final title = '人气推荐';
  Widget hotItem(msg) {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300], width: .5))),
      padding: EdgeInsets.symmetric(vertical: Rem.getPxToRem(10)),
      child: Container(
        height: Rem.getPxToRem(220),
        child: Row(
          children: <Widget>[
            Container(
              child: CachedNetworkImage(
                imageUrl: msg['list_pic_url'],
                fit: BoxFit.cover,
              ),
              height: Rem.getPxToRem(220),
              width: Rem.getPxToRem(220),
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: Rem.getPxToRem(20)),
                  margin: EdgeInsets.only(left: Rem.getPxToRem(10)),
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: Rem.getPxToRem(60),
                          width: double.infinity,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              msg['name'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Rem.getPxToRem(28)),
                            ),
                          )),
                      Container(
                        height: Rem.getPxToRem(60),
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            msg['goods_brief'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: Rem.getPxToRem(24),
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      Container(
                        height: Rem.getPxToRem(60),
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '￥${msg['retail_price']}',
                            style: TextStyle(
                                fontSize: Rem.getPxToRem(30),
                                color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> hot = [];
    data.forEach((item) => hot.add(
          hotItem(item),
        ));
    return Container(
      margin: EdgeInsets.only(top: Rem.getPxToRem(20)),
      padding: EdgeInsets.symmetric(horizontal: Rem.getPxToRem(30)),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: Rem.getPxToRem(100),
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
          Column(
            children: hot,
          )
        ],
      ),
      width: double.infinity,
    );
  }
}

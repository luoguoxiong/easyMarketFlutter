import 'package:flutter/material.dart';
import 'package:easy_market/utils/rem.dart';

class Brand extends StatelessWidget {
  final List data;
  Brand(this.data);
  final title = '品牌制造商直供';
  Widget brandItem(msg) {
    return Container(
      width: Rem.getPxToRem(375),
      height: Rem.getPxToRem(220),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Text(
              msg['name'],
              style: TextStyle(fontSize: Rem.getPxToRem(30)),
            ),
          ),
          Container(
            width: double.infinity,
            child: Text(
              '${msg['floor_price']}元起',
              style:
                  TextStyle(fontSize: Rem.getPxToRem(24), color: Colors.grey),
            ),
          ),
        ],
      ),
      padding:
          EdgeInsets.only(top: Rem.getPxToRem(10), left: Rem.getPxToRem(20)),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill, image: NetworkImage(msg['new_pic_url']))),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> brand = [];
    data.forEach((item) => brand.add(
          brandItem(item),
        ));
    return Container(
      margin: EdgeInsets.only(top: Rem.getPxToRem(20)),
      color: Colors.white,
      child: new Column(
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
          Wrap(children: brand),
        ],
      ),
    );
  }
}

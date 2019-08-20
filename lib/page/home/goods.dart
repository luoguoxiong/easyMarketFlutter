import 'package:flutter/material.dart';
import 'package:easy_market/utils/rem.dart';
import 'package:transparent_image/transparent_image.dart';

class Goods extends StatelessWidget {
  final List data;
  Goods(this.data);

  Widget goodsTypeItem(item) {
    var goodsList = item['goodsList'];
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: Rem.getPxToRem(20)),
        child: Column(
          children: <Widget>[
            Container(
              height: Rem.getPxToRem(100),
              child: Center(
                child: Text(
                  item['name'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      fontSize: Rem.getPxToRem(30)),
                ),
              ),
            ),
            Wrap(
              children: goodsList.asMap().keys.map<Widget>((temp) {
                return goodsItem(goodsList[temp], temp);
              }).toList()
                ..add(moreGoods(item['name'])),
            )
          ],
        ));
  }

  Widget moreGoods(name) {
    return Container(
      width: Rem.getPxToRem(375),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(color: Colors.grey[300], width: .2),
              top: BorderSide(color: Colors.grey[300], width: .4))),
      height: Rem.getPxToRem(460),
      child: Center(
        child: Container(
          height: Rem.getPxToRem(140),
          child: Column(
            children: <Widget>[
              Container(
                height: Rem.getPxToRem(80),
                child: Center(
                  child: Text(
                    '更多$name好物',
                    style: TextStyle(fontSize: Rem.getPxToRem(26)),
                  ),
                ),
              ),
              Image.asset(
                'assets/images/more.png',
                height: Rem.getPxToRem(60),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget goodsItem(item, index) {
    final isOdd = index % 2 == 0;
    return Container(
        width: Rem.getPxToRem(375),
        decoration: isOdd
            ? BoxDecoration(
                border: Border(
                    right: BorderSide(color: Colors.grey[300], width: .2),
                    top: BorderSide(color: Colors.grey[300], width: .4)))
            : BoxDecoration(
                border: Border(
                    left: BorderSide(color: Colors.grey[300], width: .2),
                    top: BorderSide(color: Colors.grey[300], width: .4))),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: Rem.getPxToRem(360),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: item['list_pic_url'],
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: Rem.getPxToRem(50),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  item['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              height: Rem.getPxToRem(50),
              child: Center(
                child: Text(
                  '￥${item['retail_price']}',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.map((item) => goodsTypeItem(item)).toList(),
    );
  }
}

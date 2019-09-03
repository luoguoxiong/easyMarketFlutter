/*
 * @Description: 专题详情页
 * @Author: luoguoxiong
 * @Date: 2019-08-26 16:41:58
 */

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TopicDetail extends StatefulWidget {
  TopicDetail({this.arguments});
  final Map arguments;
  @override
  State<StatefulWidget> createState() {
    return _TopicDetail();
  }
}

List getImgUrl(String str) {
  var newString = str.replaceAll('<img src=\"', '');
  var list = newString.split('">\n    ');
  List reList = [];
  for (var i = 0; i < list.length; i++) {
    if (i == 0) {
      reList.add(list[i].replaceAll('"', ''));
    } else if (i == list.length - 1) {
      reList.add(list[list.length - 1].replaceAll('">"', ''));
    } else {
      reList.add(list[i]);
    }
  }
  return reList;
}

class _TopicDetail extends State<TopicDetail> {
  @override
  Widget build(BuildContext context) {
    var str =
        '"<img src=\"//yanxuan.nosdn.127.net/75c55a13fde5eb2bc2dd6813b4c565cc.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/e27e1de2b271a28a21c10213b9df7e95.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/9d413d1d28f753cb19096b533d53418d.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/64b0f2f350969e9818a3b6c43c217325.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/a668e6ae7f1fa45565c1eac221787570.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/0d4004e19728f2707f08f4be79bbc774.jpg\">\n    <img src=\"//yanxuan.nosdn.127.net/79ee021bbe97de7ecda691de6787241f.jpg\">"';
    var a = getImgUrl(str);
    print(a);
    return Material(
      child: Center(
        child: CachedNetworkImage(
          imageUrl: 'http:${a[a.length - 1]}',
        ),
      ),
    );
  }
}

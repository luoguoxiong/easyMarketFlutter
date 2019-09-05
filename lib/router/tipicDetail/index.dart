/*
 * @Description: 专题详情页
 * @Author: luoguoxiong
 * @Date: 2019-08-26 16:41:58
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_market/component/linearBar.dart';
import 'package:easy_market/api/index.dart';

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
  for (int i = 0; i < list.length; i++) {
    if (i == 0) {
      reList.add(list[i].replaceAll('"', ''));
    } else if (i == list.length - 1) {
      reList.add(list[list.length - 1].replaceAll('">', ''));
    } else {
      reList.add(list[i]);
    }
  }
  return reList;
}

class _TopicDetail extends State<TopicDetail> {
  bool initLoading = true;
  String title;
  List content;

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  getInitData() async {
    int id = widget.arguments['id'];
    var data = await Future.wait([
      Api.getTopicMsg(id: id),
      Api.getTopicComment(valueId: id, typeId: 1, page: 1, size: 5),
      Api.getRelatedTopic(id: id),
    ]);
    var topicMsg = data[0].data;
    setState(() {
      initLoading = false;
      title = topicMsg['title'];
      content = getImgUrl(topicMsg['content']);
    });
  }

  SliverList buildDes() {
    return new SliverList(
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return new Container(
            constraints: BoxConstraints(
              minHeight: 150,
            ),
            child: CachedNetworkImage(
              imageUrl: 'http:${content[index]}',
              fit: BoxFit.fitWidth,
            ),
          );
        },
        childCount: content.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (initLoading) {
      return Material(
        child: SafeArea(
          child: Center(
            child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0)),
          ),
        ),
      );
    }
    return LinearBar(
      child: CustomScrollView(slivers: [
        buildDes(),
        SliverList(
            delegate: new SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Container(
              color: Colors.pink,
            );
          },
          childCount: 1,
        ))
      ]),
      removePadding: true,
      title: '$title',
      appBarColor: Colors.green,
    );
  }
}

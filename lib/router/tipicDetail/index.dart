/*
 * @Description: 专题详情页
 * @Author: luoguoxiong
 * @Date: 2019-08-26 16:41:58
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_market/model/index.dart';
import 'package:easy_market/component/linearBar.dart';
import 'package:easy_market/api/index.dart';
import 'package:easy_market/utils/rem.dart';
import 'package:easy_market/router/index.dart';

class TopicDetail extends StatefulWidget {
  TopicDetail({this.arguments});
  final Map arguments;
  @override
  State<StatefulWidget> createState() {
    return _TopicDetail();
  }
}

// 正则太菜，先勉强用着。。。
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

  List comment;

  int commentCount = 0;

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
    ]);
    var topicMsg = data[0].data;
    var commentMsg = data[1].data;
    setState(() {
      initLoading = false;
      title = topicMsg['title'];
      content = getImgUrl(topicMsg['content']);
      comment = commentMsg['data'];
      commentCount = commentMsg['count'];
    });
  }

  toWrite(context) {
    final model = Provider.of<Model>(context);
    if (model.token != null) {
      Router.push('/writeComment', context, {'id': widget.arguments['id']});
    } else {
      Router.push('/login', context);
    }
  }

  buildCommentList() {
    if (comment.length > 0) {
      List<Widget> commentList = [];
      for (int i = 0; i < comment.length; i++) {
        commentList.add(Container(
          padding: EdgeInsets.symmetric(
            horizontal: Rem.getPxToRem(8),
          ),
          color: Colors.white,
          child: Container(
            height: Rem.getPxToRem(160),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: .6, color: Colors.grey),
              ),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              comment[i]['user_info']['username'] == null
                                  ? '匿名用户'
                                  : comment[i]['user_info']['username']),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            comment[i]['add_time'],
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      comment[i]['content'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
      }
      return Column(
        children: commentList,
      );
    } else {
      return Container(
        height: 100,
        color: Colors.white,
        child: Center(
          child: Text(
            '留言板空空如也~ ',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
  }

  SliverList buildComment() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Rem.getPxToRem(8),
              ),
              margin: EdgeInsets.only(top: Rem.getPxToRem(20)),
              color: Colors.white,
              child: Container(
                height: Rem.getPxToRem(100),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: .5, color: Colors.grey),
                  ),
                ),
                child: Center(
                  child: Text(
                    '专题留言',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: Rem.getPxToRem(36),
                    ),
                  ),
                ),
              ),
            ),
            buildCommentList(),
            commentCount > 5
                ? Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            color: Colors.lightBlue[200],
                            highlightColor: Colors.blue[700],
                            colorBrightness: Brightness.dark,
                            splashColor: Colors.grey,
                            child: Text("更多"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            onPressed: () {
                              Router.push('/moreComment', context,
                                  {'id': widget.arguments['id']});
                            },
                          ),
                        ),
                        Container(
                          width: 20,
                        ),
                        Expanded(
                          child: FlatButton(
                            color: Colors.lightBlue[200],
                            highlightColor: Colors.blue[700],
                            colorBrightness: Brightness.dark,
                            splashColor: Colors.grey,
                            child: Text("留言"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            onPressed: () {
                              toWrite(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    color: Colors.white,
                    height: Rem.getPxToRem(120),
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                        Rem.getPxToRem(20),
                        Rem.getPxToRem(8),
                        Rem.getPxToRem(20),
                        Rem.getPxToRem(8)),
                    child: FlatButton(
                      color: Colors.lightBlue[200],
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      splashColor: Colors.grey,
                      child: Text("我要留言"),
                      onPressed: () {
                        toWrite(context);
                      },
                    ),
                  )
          ],
        );
      }, childCount: 1),
    );
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
        buildComment(),
      ]),
      removePadding: true,
      title: '$title',
      appBarColor: Colors.green,
    );
  }
}

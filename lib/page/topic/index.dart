import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_market/api/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_market/utils/rem.dart';
import 'package:easy_market/router/index.dart';

class Topic extends StatefulWidget {
  @override
  _InfiniteListViewState createState() => new _InfiniteListViewState();
}

class _InfiniteListViewState extends State<Topic> {
  static String loadingTag = "##loading##"; //表尾标记

  bool isFirstLoading = true; // is第一次加载

  final int pageSize = 5; // 每次加载的条数

  int page = 1; // 当前加载的页数

  int total = 0;

  List topicData = ['##loading##'];

  @override
  void initState() {
    super.initState();

    _getInitData();
  }

// 第一次加载
  _getInitData() async {
    Response data = await Api.getTopicData(page: 1, size: pageSize);
    topicData.insertAll(0, data.data['data']);
    setState(() {
      isFirstLoading = false;
      page = 2;
      total = data.data['count'];
    });
  }

// 加载更多
  _getMore() async {
    // 为了效果所以延迟1s
    Future.delayed(Duration(seconds: 1)).then((e) async {
      Response data = await Api.getTopicData(page: page, size: pageSize);
      topicData.insertAll(topicData.length - 1, data.data['data']);
      setState(() {
        page = page + 1;
        total = data.data['count'];
      });
    });
  }

// 下拉刷新数据
  Future<Null> _handleRefresh() async {
    Response data = await Api.getTopicData(page: 1, size: pageSize);
    List newData = ['##loading##'];
    newData.insertAll(0, data.data['data']);
    print(newData.length);
    setState(() {
      page = 2;
      total = data.data['count'];
      topicData = newData;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstLoading) {
      return Center(
        child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(strokeWidth: 2.0)),
      );
    }
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        itemCount: topicData.length,
        itemBuilder: (context, index) {
          //如果到了表尾
          if (topicData[index] == loadingTag) {
            //不足100条，继续获取数据
            if (topicData.length - 1 < total) {
              _getMore();

              return Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(strokeWidth: 2.0)),
              );
            } else {
              return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "没有更多了",
                    style: TextStyle(color: Colors.grey),
                  ));
            }
          }
          Widget widget = Card(
              color: Colors.white,
              elevation: 4.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                  child: Column(
                children: <Widget>[
                  Container(
                    height: Rem.getPxToRem(400),
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: topicData[index]['scene_pic_url'],
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Center(
                      child: Text(
                        '${topicData[index]['title']}',
                        style: TextStyle(fontSize: Rem.getPxToRem(32)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Center(
                      child: Text(
                        '${topicData[index]['subtitle']}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey, fontSize: Rem.getPxToRem(30)),
                      ),
                    ),
                  )
                ],
              )));
          return Router.link(
              widget, '/topicDetail', context, {'id': topicData[index]['id']});
        },
      ),
    );
  }
}

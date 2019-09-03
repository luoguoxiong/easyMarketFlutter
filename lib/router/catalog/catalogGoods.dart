import 'package:flutter/material.dart';
import 'package:easy_market/api/index.dart';
import 'package:easy_market/utils/help.dart';
import 'package:easy_market/utils/rem.dart';
import 'package:easy_market/router/index.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CatalogGoods extends StatefulWidget {
  CatalogGoods(this.id);
  final int id;
  @override
  State<StatefulWidget> createState() {
    return _CatalogGoods();
  }
}

class _CatalogGoods extends State<CatalogGoods>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = true;

  int page = 1;

  int size = 8;

  int total = 0;

  static int chunk = 2; //没列显示多少个商品

  List<dynamic> dataList = ['isLoading'];

  @override
  void initState() {
    super.initState();
    _getInitData();
  }

  @override
  bool get wantKeepAlive => true;

  _getInitData() async {
    var data = await Api.getGoods(page: 1, size: size, categoryId: widget.id);
    var resData = data.data;
    var goodsList = resData['data'];
    var newDataList = listToSort(toSort: goodsList, chunk: chunk);
    dataList.insertAll(dataList.length - 1, newDataList);
    setState(() {
      isLoading = false;
      total = resData['count'];
      page = page + 1;
      dataList = dataList;
    });
  }

// 加载更多
  _getMore() async {
    // 为了效果所以延迟1s
    Future.delayed(Duration(seconds: 1)).then((e) async {
      var data =
          await Api.getGoods(page: page, size: size, categoryId: widget.id);
      var resData = data.data;
      var goodsList = resData['data'];
      var newDataList = listToSort(toSort: goodsList, chunk: chunk);
      dataList.insertAll(dataList.length - 1, newDataList);
      setState(() {
        page = page + 1;
        total = data.data['count'];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

// 下拉刷新数据
  Future<Null> _handleRefresh() async {
    var data = await Api.getGoods(page: 1, size: size, categoryId: widget.id);
    List newData = ['isLoading'];
    var resData = data.data;
    var goodsList = resData['data'];
    var newDataList = listToSort(toSort: goodsList, chunk: chunk);
    newData.insertAll(0, newDataList);
    setState(() {
      page = 2;
      total = resData['count'];
      dataList = newData;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (isLoading) {
      return Center(
        child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(strokeWidth: 2.0)),
      );
    } else {
      return RefreshIndicator(
        child: ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (BuildContext context, int index) {
              if (dataList[index] == 'isLoading') {
                if ((dataList.length - 1) * 2 < total) {
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
              List<Widget> listwidget = [];
              for (var i = 0; i < dataList[index].length; i++) {
                var item = dataList[index][i];
                var paddingDes;
                if (index == 0 && i == 0) {
                  paddingDes = EdgeInsets.fromLTRB(4, 4, 2, 2);
                }
                if (index == 0 && i == 1) {
                  paddingDes = EdgeInsets.fromLTRB(2, 4, 4, 2);
                }
                if (index == dataList.length - 2 && i == 0) {
                  paddingDes = EdgeInsets.fromLTRB(4, 2, 2, 4);
                }
                if (index == dataList.length - 2 && i == 1) {
                  paddingDes = EdgeInsets.fromLTRB(2, 2, 4, 4);
                } else {
                  if (i == 0) {
                    paddingDes = EdgeInsets.fromLTRB(4, 2, 2, 2);
                  } else {
                    paddingDes = EdgeInsets.fromLTRB(2, 2, 4, 2);
                  }
                }
                listwidget.add(Router.link(
                    Container(
                        width: Rem.getPxToRem(375),
                        padding: paddingDes,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.grey[500],
                                  blurRadius: Rem.getPxToRem(1),
                                  spreadRadius: 0,
                                )
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: Rem.getPxToRem(360),
                                child: CachedNetworkImage(
                                  imageUrl: item['list_pic_url'],
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                child: Center(
                                  child: Text(
                                    "￥${item['retail_price']}",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: Rem.getPxToRem(30)),
                                  ),
                                ),
                              ),
                              Container(
                                height: Rem.getPxToRem(50),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: Text(
                                    item['name'],
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: Rem.getPxToRem(28)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    '/goodsDetail',
                    context,
                    {
                      'id': item['id'],
                    }));
              }
              return Row(children: listwidget);
            }),
        onRefresh: _handleRefresh,
      );
    }
  }
}

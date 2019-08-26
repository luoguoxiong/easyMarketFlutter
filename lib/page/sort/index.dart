import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_market/component/verticalTab.dart';
import 'package:easy_market/api/index.dart';
import 'package:easy_market/router/index.dart';

class Sort extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Sort();
  }
}

class _Sort extends State<Sort> {
  int activeIndex = 0;
  List tabs = [];

  int goodsCount = 0;

  bool isLoading = true;

  bool isRequest = true;

  Map currentCategory;

  @override
  void initState() {
    super.initState();
    getInitData();
  }

  getInitData() async {
    var response = await Future.wait([Api.getSortTabs(), Api.getGoodsCount()]);
    setState(() {
      tabs = response[0].data['categoryList'];
      goodsCount = response[1].data['goodsCount'];
      isLoading = false;
    });
    if (tabs.isNotEmpty) {
      var id = response[0].data['categoryList'][0]['id'];
      getCategoryMsg(id);
    }
  }

  getCategoryMsg(id) async {
    setState(() {
      isRequest = true;
    });
    var data = await Api.getCategoryMsg(id: id);
    setState(() {
      currentCategory = data.data['currentCategory'];
      isRequest = false;
    });
  }

// 搜索框
  Widget buildSearch(BuildContext context) {
    Widget widget = Container(
        height: 46,
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(color: Colors.grey[400], width: .5))),
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 237, 237, 237),
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Text('搜索商品，共$goodsCount款好物',
                style: TextStyle(color: Color.fromARGB(255, 102, 102, 102))),
          ),
        ));
    return Router.link(widget, '/search', context);
  }

  Widget buildContent() {
    if (isRequest) {
      return Center(
        child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(strokeWidth: 2.0)),
      );
    } else {
      return CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      height: 120,
                      child: CachedNetworkImage(
                        imageUrl: currentCategory['wap_banner_url'],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: 120,
                      child: Center(
                        child: Text(
                          '${currentCategory['front_name']}',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }, childCount: 1),
          ),
          SliverPadding(
              padding: const EdgeInsets.all(4.0),
              sliver: SliverGrid(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  childAspectRatio: .8,
                ),
                delegate: new SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Widget widget = Card(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: currentCategory['subCategoryList']
                                  [index]['wap_banner_url'],
                            ),
                            flex: 4,
                          ),
                          Expanded(
                            child: Text(currentCategory['subCategoryList']
                                [index]['name']),
                            flex: 1,
                          )
                        ],
                      ),
                    );
                    return Router.link(
                      widget,
                      '/catalog',
                      context,
                      {'id': currentCategory['subCategoryList'][index]['id']},
                    );
                  },
                  childCount: currentCategory['subCategoryList'].length,
                ),
              )),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(strokeWidth: 2.0)),
      );
    } else {
      List<String> newTabs = [];
      for (var i = 0; i < tabs.length; i++) {
        newTabs.add(tabs[i]['name']);
      }
      return Column(
        children: <Widget>[
          buildSearch(context),
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  VerticalTab(
                    tabs: newTabs,
                    onTabChange: (index) {
                      getCategoryMsg(tabs[index]['id']);
                    },
                    activeIndex: 0,
                  ),
                  Expanded(
                    child: buildContent(),
                  )
                ],
              ),
            ),
          )
        ],
      );
    }
  }
}

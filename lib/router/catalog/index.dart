/*
 * @Description: 商品分类页
 * @Author: luoguoxiong
 * @Date: 2019-08-26 15:59:04
 */
import 'package:flutter/material.dart';
import 'package:easy_market/component/tabAppBar.dart';
import 'package:easy_market/api/index.dart';
import './catalogGoods.dart';

class Catalog extends StatefulWidget {
  Catalog({this.arguments});
  final Map arguments;
  @override
  State<StatefulWidget> createState() {
    return _Catalog();
  }
}

class _Catalog extends State<Catalog> with TickerProviderStateMixin {
  TabController mController;
  List<dynamic> catalogList = [];
  int activeIndex;
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    List<String> tabItem = [];
    for (var i = 0; i < catalogList.length; i++) {
      tabItem.add(catalogList[i]['name']);
    }
    return Scaffold(
        appBar: TabAppBar(
          tabs: tabItem,
          controller: mController,
          title: '${tabItem.length > 0 ? tabItem[activeIndex] : '奇趣'}分类',
        ).build(context),
        body: isLoading
            ? Center(
                child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(strokeWidth: 2.0)),
              )
            : _tabBarView());
  }

  // 第一次加载
  _getInitData() async {
    var data = await Api.getBrotherCatalog(id: widget.arguments['id']);
    List<dynamic> brotherCategory = data.data['brotherCategory'];
    int index;
    for (var i = 0; i < brotherCategory.length; i++) {
      if (widget.arguments['id'] == brotherCategory[i]['id']) {
        index = i;
      }
    }
    if (mController != null) {
      mController.dispose();
    }
    setState(() {
      isLoading = false;
      catalogList = brotherCategory;
      activeIndex = index;
      mController = TabController(
          length: brotherCategory.length, vsync: this, initialIndex: index);
    });
    mController.addListener(() {
      setState(() {
        activeIndex = mController.index;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    mController = TabController(length: catalogList.length, vsync: this);
    _getInitData();
  }

  @override
  void dispose() {
    super.dispose();
    mController.dispose();
  }

  Widget _tabBarView() {
    return TabBarView(
      controller: mController,
      children: catalogList.map((item) {
        return CatalogGoods(item['id']);
      }).toList(),
    );
  }
}

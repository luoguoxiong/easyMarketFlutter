import 'package:flutter/material.dart';
import 'package:easy_market/page/home/index.dart';
import 'package:easy_market/page/topic/index.dart';
import 'package:easy_market/page/sort/index.dart';
import 'package:easy_market/page/mine/index.dart';
import 'package:easy_market/page/cart/index.dart';
import 'package:easy_market/page/wrapper.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ApplicationPageState();
  }
}

class _Item {
  String name, activeIcon, normalIcon;

  _Item(this.name, this.activeIcon, this.normalIcon);
}

class _ApplicationPageState extends State<App> {
  int _currentPageIndex = 0;

  final pageList = [
    WrapKeepState(Home()),
    WrapKeepState(Topic()),
    WrapKeepState(Sort()),
    // WrapKeepState(Cart()),
    Cart(),
    WrapKeepState(Mine()),
  ];

  Widget getPage(_index) {
    return pageList[_index];
  }

  final itemNames = [
    _Item('首页', 'assets/images/ic_tab_home_active.png',
        'assets/images/ic_tab_home_normal.png'),
    _Item('专题', 'assets/images/ic_tab_subject_active.png',
        'assets/images/ic_tab_subject_normal.png'),
    _Item('分类', 'assets/images/ic_tab_group_active.png',
        'assets/images/ic_tab_group_normal.png'),
    _Item('购物车', 'assets/images/ic_tab_shiji_active.png',
        'assets/images/ic_tab_shiji_normal.png'),
    _Item('我的', 'assets/images/ic_tab_profile_active.png',
        'assets/images/ic_tab_profile_normal.png')
  ];
  List<BottomNavigationBarItem> itemList;
  @override
  void initState() {
    super.initState();
    if (itemList == null) {
      itemList = itemNames
          .map((item) => BottomNavigationBarItem(
              icon: Image.asset(
                item.normalIcon,
                width: 30.0,
                height: 30.0,
              ),
              title: Text(
                item.name,
                style: TextStyle(fontSize: 10.0),
              ),
              activeIcon:
                  Image.asset(item.activeIcon, width: 30.0, height: 30.0)))
          .toList();
    }
  }

  final pageController = PageController();

  void onTap(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromARGB(1, 200, 200, 200),
      // appBar: new PreferredSize(
      //   child: new Container(
      //     // decoration: new BoxDecoration(
      //     //   gradient:
      //     //       new LinearGradient(colors: [Colors.teal, Colors.lightGreen]),
      //     // ),
      //     color: Colors.green,
      //   ),
      //   preferredSize: new Size(MediaQuery.of(context).size.width, 0),
      // ),
      // PageView+wrapper封装保存页面状态
      body: PageView(
        children: pageList,
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(), // 禁止滑动
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: itemList,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
            pageController.jumpToPage(index);
          });
        },
        iconSize: 24,
        currentIndex: _currentPageIndex,
        fixedColor: Color.fromARGB(255, 0, 188, 96),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

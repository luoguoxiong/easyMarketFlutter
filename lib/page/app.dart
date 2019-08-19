import 'package:flutter/material.dart';
import 'package:easy_market/component/tab.dart';
import 'package:easy_market/page/topic.dart';
import 'package:easy_market/page/mine.dart';
import 'package:easy_market/page/sort.dart';
import './home/index.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ApplicationPageState();
  }
}

class _ApplicationPageState extends State<App> {
  int _currentPageIndex = 0;

  final pageList = [
    Home(),
    Topic(),
    Sort(),
    Mine(),
  ];

  final tabitems = [
    TabItem('首页', 'assets/images/tab_home_default.png',
        'assets/images/tab_home_active.png'),
    TabItem('专题', 'assets/images/tab_copy_default.png',
        'assets/images/tab_copy_active.png'),
    TabItem('分类', 'assets/images/tab_sort_default.png',
        'assets/images/tab_sort_active.png'),
    TabItem('我的', 'assets/images/tab_mine_default.png',
        'assets/images/tab_mine_active.png'),
  ];

  Widget getPage(_index) {
    return pageList[_index];
  }

  Widget _getPagesWidget(int index) {
    return Offstage(
      offstage: _currentPageIndex != index,
      child: TickerMode(
        enabled: _currentPageIndex == index,
        child: pageList[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new PreferredSize(
          child: new Container(
            decoration: new BoxDecoration(
              gradient:
                  new LinearGradient(colors: [Colors.teal, Colors.lightGreen]),
            ),
          ),
          preferredSize: new Size(MediaQuery.of(context).size.width, 0),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: new Stack(
                children: [
                  _getPagesWidget(0),
                  _getPagesWidget(1),
                  _getPagesWidget(2),
                  _getPagesWidget(3),
                ],
              ),
            ),
            TabOp(
              currentIndex: _currentPageIndex,
              onTabChange: (int index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              items: tabitems,
            ),
          ],
        ));
  }
}

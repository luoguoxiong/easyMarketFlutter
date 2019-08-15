import 'package:flutter/material.dart';
import '../component/tab.dart';
import 'home/index.dart';
import 'topic.dart';
import 'sort.dart';
import 'mine.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _App();
  }
}

class _App extends State<App> {
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

  int _selectIndex = 0;

  List<BottomNavigationBarItem> tabItemList;

  List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      Home(),
      Topic(),
      Sort(),
      Mine(),
    ];
  }

//Stack（层叠布局）+Offstage组合,解决状态被重置的问题
  Widget _getPagesWidget(int index) {
    return pages[index];
  }

  @override
  void didUpdateWidget(App oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      body: _getPagesWidget(_selectIndex),
      backgroundColor: Color.fromARGB(255, 245, 245, 249),
      bottomNavigationBar: TabOp(
        currentIndex: _selectIndex,
        onTabChange: (int index) {
          setState(() {
            _selectIndex = index;
          });
        },
        items: tabitems,
      ),
    );
  }
}

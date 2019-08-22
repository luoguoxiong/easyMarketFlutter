import 'package:flutter/material.dart';

class Sort extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Sort();
  }
}

class _Sort extends State<Sort> with SingleTickerProviderStateMixin {
  var controller;
  var tabs = <Tab>[
    Tab(
      text: "Tab1",
    ),
    Tab(
      text: "Tab2",
    ),
    Tab(
      text: "Tab3",
    ),
    Tab(
      text: "Tab4",
    ),
    Tab(
      text: "Tab5",
    ),
    Tab(
      text: "Tab6",
    ),
    Tab(
      text: "Tab7",
    ),
    Tab(
      text: "Tab8Tab8Tab8Tab8Tab8",
    ),
  ];

  @override
  void initState() {
    controller = TabController(
      length: tabs.length,
      vsync: this, //动画效果的异步处理，默认格式，背下来即可
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: tabs,
            controller: controller,
            //配置控制器
            isScrollable: true,
            indicatorColor: Color(0xffff0000),
            indicatorWeight: 1,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.only(bottom: 10.0),
            labelPadding: EdgeInsets.only(left: 20),
            labelColor: Color(0xff333333),
            labelStyle: TextStyle(
              fontSize: 15.0,
            ),
            unselectedLabelColor: Color(0xffffffff),
            unselectedLabelStyle: TextStyle(
              fontSize: 12.0,
            ),
          ),
        ),
        body: TabBarView(
            controller: controller, //配置控制器
            children: tabs
                .map((Tab tab) => Container(
                      child: Center(
                        child: Text(tab.text),
                      ),
                    ))
                .toList()),
      ),
    );
  }

  //当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

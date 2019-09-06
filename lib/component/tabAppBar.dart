/*
 * @Description: 自定义有tab切换的appBar
 * @Author: luoguoxiong
 * @Date: 2019-08-28 14:47:00
 */
import 'package:flutter/material.dart';
import 'package:easy_market/utils/rem.dart';

class TabAppBar extends StatelessWidget {
  TabAppBar({this.tabs, this.controller, this.title});

  final List<String> tabs;

  final TabController controller;

  final String title;
  Widget buildAppBar(BuildContext context) {
    return new Container(
      width: double.infinity,
      padding: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: new Container(
        child: Row(
          children: <Widget>[
            InkResponse(
              child: Container(
                width: Rem.getPxToRem(100),
                child: Center(
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white, fontSize: Rem.getPxToRem(38)),
                ),
              ),
            ),
            Container(
              width: Rem.getPxToRem(100),
            ),
          ],
        ),
        height: Rem.getPxToRem(100),
      ),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(colors: [Colors.teal, Colors.green]),
      ),
    );
  }

  Widget buildTabBar() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          new BoxShadow(
            color: Colors.grey[500],
            blurRadius: Rem.getPxToRem(1),
            spreadRadius: 0.8,
          )
        ]),
        child: TabBar(
          isScrollable: true,
          controller: this.controller,
          labelStyle: TextStyle(
              fontSize: Rem.getPxToRem(30), fontWeight: FontWeight.bold),
          labelColor: Colors.green,
          unselectedLabelColor: Colors.black45,
          indicatorColor: Colors.green,
          indicatorWeight: Rem.getPxToRem(2),
          tabs: tabs.map((item) {
            return Container(
              height: Rem.getPxToRem(60),
              child: Center(child: Text(item)),
            );
          }).toList(),
        ));
  }

  @override
  PreferredSize build(BuildContext context) {
    return new PreferredSize(
      child: Column(
        children: tabs.length > 0
            ? [buildAppBar(context), buildTabBar()]
            : [
                buildAppBar(context),
              ],
      ),
      preferredSize: new Size(
        MediaQuery.of(context).size.width,
        tabs.length > 0 ? Rem.getPxToRem(164) : Rem.getPxToRem(100),
      ),
    );
  }
}

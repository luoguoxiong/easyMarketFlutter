/*
 * @Description: 自定义Tab
 * @Author: luoguoxiong
 * @Date: 2019-08-15 10:08:01
 */
import 'package:flutter/material.dart';
import '../utils/rem.dart';

class TabItem {
  final String name, defaultIcon, activeIcon;
  TabItem(this.name, this.defaultIcon, this.activeIcon);
}

class TabOp extends StatelessWidget {
  TabOp({Key key, this.currentIndex, this.onTabChange, this.items})
      : super(key: key);
  final int currentIndex;
  final ValueChanged<int> onTabChange;
  final List<TabItem> items;
  _handleTap(index) {
    if (currentIndex != index) {
      onTabChange(index);
    }
  }

  Widget build(BuildContext context) {
    final List<Widget> tabs = List<Widget>(items.length);
    for (var i = 0; i < items.length; i++) {
      tabs[i] = Expanded(
        child: InkResponse(
            onTap: () {
              _handleTap(i);
            },
            child: Container(
              height: Rem.getPxToRem(110),
              child: new Column(
                children: <Widget>[
                  Expanded(
                    child: currentIndex == i
                        ? AnimateTab(icon: items[i].activeIcon)
                        : Image.asset(
                            currentIndex == i
                                ? items[i].activeIcon
                                : items[i].defaultIcon,
                            height: Rem.getPxToRem(40),
                            width: Rem.getPxToRem(40),
                          ),
                    flex: 8,
                  ),
                  Expanded(
                    child: new Text(
                      items[i].name,
                      style: TextStyle(
                          fontSize: Rem.getPxToRem(24),
                          color: currentIndex == i
                              ? Color.fromARGB(255, 33, 150, 243)
                              : Colors.black),
                    ),
                    flex: 4,
                  )
                ],
              ),
            )),
      );
    }
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new Border(top: BorderSide(width: 1, color: Colors.grey[300])),
      ),
      child: Row(
        children: tabs,
      ),
    );
  }
}

class AnimateTab extends StatefulWidget {
  AnimateTab({Key key, this.icon}) : super(key: key);
  final String icon;
  @override
  _AnimateTab createState() => new _AnimateTab();
}

class _AnimateTab extends State<AnimateTab>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Cubic(0, -5, .5, 5));
    animation = new Tween(begin: Rem.getPxToRem(35), end: Rem.getPxToRem(40))
        .animate(animation)
          ..addListener(() {
            setState(() {});
          });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(widget.icon,
        width: animation.value, height: animation.value);
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

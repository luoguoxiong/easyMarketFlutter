import 'package:flutter/material.dart';
import 'package:easy_market/utils/rem.dart';

const APPBAR_SCROLL_OFFSET = 150;

class LinearBar extends StatefulWidget {
  LinearBar({this.removePadding, this.child, this.appBarColor, this.title});

  final bool removePadding;
  final Widget child;
  final Color appBarColor;
  final String title;
  _LinearBar createState() => _LinearBar();
}

class _LinearBar extends State<LinearBar> {
  double appBarAlpha = 0;

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top:
                  widget.removePadding ? MediaQuery.of(context).padding.top : 0,
            ),
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: NotificationListener(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification &&
                      scrollNotification.depth == 0) {
                    _onScroll(scrollNotification.metrics.pixels);
                  }
                  return null;
                },
                child: widget.child,
              ),
            ),
          ),
          Opacity(
              //改变透明度都可以使用 Opacity 将其包裹
              opacity: appBarAlpha,
              child: Container(
                height:
                    Rem.getPxToRem(100) + MediaQuery.of(context).padding.top,
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                decoration: BoxDecoration(color: widget.appBarColor),
              )),
          Container(
            height: Rem.getPxToRem(100) + MediaQuery.of(context).padding.top,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(color: Colors.transparent),
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
                      widget.title,
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
          ),
        ],
      ),
    );
  }
}

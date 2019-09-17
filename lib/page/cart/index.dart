import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Cart();
  }
}

class _Cart extends State<Cart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final model = Provider.of<Model>(context);
    // return Center(
    //   child: model.token != null ? Text('${model.token}') : Text('未登录'),
    // );
    return Scaffold(
      key: _scaffoldKey,
      appBar: new PreferredSize(
        child: new Container(
          color: Colors.green,
        ),
        preferredSize: new Size(MediaQuery.of(context).size.width, 0),
      ),
      body: Container(
        child: WebviewScaffold(
          url: 'https://www.zhihu.com/',
        ),
      ),
    );
  }
}

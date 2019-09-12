/*
 * @Description: main
 * @Author: luoguoxiong
 * @Date: 2019-08-15 10:08:01
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:easy_market/utils/rem.dart';
import 'package:easy_market/router/index.dart';
import 'package:easy_market/model/index.dart';
import 'package:easy_market/utils/cache.dart';
import 'package:easy_market/page/index.dart';

void main() async {
  //  * https: //stackoverflow.com/questions/57689492/flutter-unhandled-exception-servicesbinding-defaultbinarymessenger-was-accesse
  // 异步获取SpUtil时，版本升级会有问题WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  var sq = await SpUtil.getInstance();
  var token = sq.getString('token');
  var userName = sq.getString('userName');
  runApp(MyApp(token, userName));

  // if (Platform.isAndroid) {
  //   //设置Android头部的导航栏透明
  //   SystemUiOverlayStyle systemUiOverlayStyle =
  //       SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  //   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  // }
  //白色
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
      .copyWith(statusBarBrightness: Brightness.dark));
}

class MyApp extends StatelessWidget {
  MyApp(this.token, this.userName);

  final String token;

  final String userName;

  @override
  Widget build(BuildContext context) {
    // 设置设计稿的宽度

    Rem.setDesignWidth(750.0);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => Model(token, userName)),
      ],
      child: Consumer<Model>(
        builder: (context, model, widget) {
          return RestartWidget(
            child: MaterialApp(
              theme: ThemeData(backgroundColor: Colors.transparent),
              // 监听路由跳转
              onGenerateRoute: (RouteSettings settings) {
                return Router.run(settings);
              },
              home: Scaffold(
                resizeToAvoidBottomPadding: false,
                body: Page(),
              ),
            ),
          );
        },
      ),
    );
  }
}

///这个组件用来重新加载整个child Widget的。当我们需要重启APP的时候，可以使用这个方案
///https://stackoverflow.com/questions/50115311/flutter-how-to-force-an-application-restart-in-production-mode
class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  static restartApp(BuildContext context) {
    final _RestartWidgetState state =
        context.ancestorStateOfType(const TypeMatcher<_RestartWidgetState>());
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}

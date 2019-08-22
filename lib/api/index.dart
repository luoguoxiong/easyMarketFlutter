import 'package:easy_market/utils/http.dart';

var http = new HttpUtils();

class Api {
  // 获取首页数据
  static Future getHomeData() async {
    return await http.get('/');
  }

  // 获取专题页数据
  static Future getTopicData({int page, int size}) async {
    return await http.get('/topic/list', {'page': page, 'size': size});
  }
}

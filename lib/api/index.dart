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

  // 获取分类页tabList
  static Future getSortTabs() async {
    return await http.get('/catalog/index');
  }

  // 获取所有商品的数量
  static Future getGoodsCount() async {
    return await http.get('/goods/count');
  }

  // 获取某分类的相关信息
  static Future getCategoryMsg({int id}) async {
    return await http.get('/catalog/current', {'id': id});
  }

  // 通过手机号码登录
  static Future loginByMobile({String mobile, String password}) async {
    return await http
        .post('/auth/loginByMobile', {'mobile': mobile, 'password': password});
  }

  // 获取兄弟分类
  static Future getBrotherCatalog({int id}) async {
    return await http.get('/goods/category', {'id': id});
  }

  // 某分类的商品
  static Future getGoods({int page, int size, int categoryId}) async {
    return await http.get(
        '/goods/list', {'page': page, 'size': size, 'categoryId': categoryId});
  }
}

import 'package:dio/dio.dart';

class HttpUtils {
  static Dio http;
  HttpUtils() {
    BaseOptions options =
        new BaseOptions(baseUrl: 'http://202.96.155.121:8888/api', headers: {
      'x-nideshop-token': '',
    });
    http = new Dio(options);
    // 添加拦截器
    http.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      return options; //continue
    }, onResponse: (Response response) {
      if (response.data['errno'] == 0) {
        return response.data['data'];
      } else {
        return null;
      }
    }, onError: (DioError e) {
      print(e);
      return e; //continue
    }));
    // 开启日志
    // http.interceptors.add(LogInterceptor(responseBody: false));
  }
  Future get(String url, [Map<String, dynamic> params]) {
    return http.get(url, queryParameters: params == null ? {} : params);
  }

  Future post(String url, [Map<String, dynamic> params]) {
    return http.post(url, data: params == null ? {} : params);
  }
}

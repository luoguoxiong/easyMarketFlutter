/*
 * @Description: Dio的封装
 * @Author: luoguoxiong
 * @Date: 2019-08-26 17:29:18
 */
import 'package:dio/dio.dart';

class HttpUtils {
  static Dio http;
  String baseApi = 'http://202.96.155.121:8888/api';

  HttpUtils() {
    BaseOptions options = new BaseOptions(
      baseUrl: baseApi,
    );
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

  Future postToken(String url, String token, [Map<String, dynamic> params]) {
    Dio req = setToken(token);
    return req.post(url, data: params == null ? {} : params);
  }

  Future getToken(String url, String token, [Map<String, dynamic> params]) {
    Dio req = setToken(token);
    return req.get(url, queryParameters: params == null ? {} : params);
  }

  setToken(String token) {
    BaseOptions options = new BaseOptions(
      baseUrl: baseApi,
      headers: {
        'x-nideshop-token': token,
      },
    );
    Dio req = new Dio(options);
    // 添加拦截器
    req.interceptors
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
    return req;
  }
}

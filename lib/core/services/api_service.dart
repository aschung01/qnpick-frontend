import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/helpers/dio_auth_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Dio customDio() {
  var dioOptions = BaseOptions(
    baseUrl: endPointUrl,
    connectTimeout: 500000,
    receiveTimeout: 500000,
  );
  Dio dio = Dio(dioOptions);
  dio.interceptors.add(
    DioAuthInterceptor(),
  );

  return dio;
}

Dio customDioWithoutToken() {
  var dioOptions = BaseOptions(
    baseUrl: endPointUrl,
    connectTimeout: 500000,
    receiveTimeout: 500000,
  );
  Dio dio = Dio(dioOptions);

  return dio;
}

abstract class ApiService {
  static Dio dio = customDio();
  static Dio dioWithoutToken = customDioWithoutToken();
  static const storage = FlutterSecureStorage();

  static Future<dynamic> getWithoutToken(
      String path, Map<String, dynamic>? parameters) async {
    try {
      var response = await dioWithoutToken.get(
        path,
        queryParameters: parameters,
      );
      if (response.statusCode == 200) {
        log(response.toString());
        return response;
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  static Future<dynamic> postWithoutToken(String path, dynamic data) async {
    try {
      var response = await dioWithoutToken.post(
        path,
        data: data,
      );
      log(response.toString());
      return response;
    } on DioError catch (e) {
      print(e);
    }
  }

  static Future<dynamic> get(
      String path, Map<String, dynamic>? parameters) async {
    try {
      var response = await dio.get(
        path,
        queryParameters: parameters,
      );
      if (response.statusCode == 200) {
        log(response.toString());
        return response;
      } else if (response.data == null) {
        print(response.statusCode);
        // Get.dialog(const ConnectionErrorDialog());
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  static Future<dynamic> post(String path, dynamic data) async {
    try {
      var response = await dio.post(
        path,
        data: data,
      );
      log(response.toString());
      return response;
    } on DioError catch (e) {
      print(e);
      inspect(e);
    }
  }
}

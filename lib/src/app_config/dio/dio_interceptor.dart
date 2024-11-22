import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:showbox/src/constant/constants.dart';

class DioInterceptor extends Interceptor {
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String token = AppConstants.bearerToken;
    options.headers['Authorization'] = 'Bearer $token';
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(response, ResponseInterceptorHandler handler) async {
    String apiPath = response.requestOptions.path;
    String successLog = 'SUCCESS PATH => [${response.requestOptions.method}] $apiPath'; 
    log('\x1B[32m$successLog\x1B[0m');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errormsg = 'ERROR PATH => [${err.response!.requestOptions.method}] ${err.response!.requestOptions.path}';
    log('\x1B[31m$errormsg\x1B[0m');
    return super.onError(err, handler);
  }
}
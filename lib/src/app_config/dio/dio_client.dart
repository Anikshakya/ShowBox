import 'package:dio/dio.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/app_config/dio/dio_interceptor.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: AppConstants.baseUrl,
    headers: <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    receiveDataWhenStatusError: true,
    // connectTimeout: const Duration(seconds: 30),
    // receiveTimeout: const Duration(seconds: 30)
  ),
)..interceptors.add(DioInterceptor());
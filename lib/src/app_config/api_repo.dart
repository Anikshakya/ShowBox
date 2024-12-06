import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:showbox/src/app_config/dio/dio_client.dart';

class ApiRepo {
  static apiPost(apiPath, [apiName]) async {
    try {
      var response = await dio.post(apiPath);
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException  catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  static apiGet(apiPath, [apiName]) async {
    try {
      var response = await dio.get(apiPath);
      if (response.statusCode == 200) {
        return response.data;
      } 
    } on DioException  catch (e) {
      log(e.toString());
      return;
    } catch (e) {
      log(e.toString());
    }
  }
}
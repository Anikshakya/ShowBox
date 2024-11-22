import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:showbox/src/app_config/dio/dio_client.dart';

class ApiRepo {
    static apiPost(url, params) async {
    try {
      var response = await dio.post(url, data: params);
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException  catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  static apiGet(url) async {
    try {
      var response = await dio.get(url);
      return response.data;
    } on DioException  catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }
}
import 'dart:developer';

import 'package:get/get.dart';
import 'package:showbox/src/app_config/api_repo.dart';

class SearchAllController extends GetxController {
  late RxBool isSearchListLoading = true.obs;

  var searchList = <dynamic>[].obs;

  searchForMovie({keyWord}) async {
    isSearchListLoading(true);

    var data = {
      "query" : keyWord
    };

    try {
      var response = await ApiRepo.apiGet(
        'https://api.themoviedb.org/3/search/multi',
        data,
        "Search"
      );
      if (response != null) {
        searchList.value = response['results'];
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isSearchListLoading(false);
    }
  }
}

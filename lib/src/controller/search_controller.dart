import 'package:get/get.dart';
import 'dart:developer';

import 'package:showbox/src/app_config/api_repo.dart';

class SearchhController extends GetxController {
  late RxBool isSearchListLoading = false.obs;
  late RxBool hasSearched = false.obs;

  dynamic movieSearchList = [].obs;
  dynamic seriesSearchList = [].obs;

  @override
  void onInit() {
    super.onInit();
    hasSearched.value = false;
  }

  searchForMovie(String keyword) async {
    isSearchListLoading(true);
    hasSearched.value = true;
    movieSearchList.clear();
    seriesSearchList.clear();
    try {
      var response = await ApiRepo.apiGet(
          'https://api.themoviedb.org/3/search/multi?query=$keyword',
          ""
        );
      if (response != null) {
        for (var allData in response['results']) {
          if (allData['media_type'] == "tv") {
            seriesSearchList.add(allData);
          } else if (allData['media_type'] == "movie") {
            movieSearchList.add(allData);
          }
        }
      }
    } catch (e) {
      log("Error in search: $e");
    } finally {
      isSearchListLoading(false);
      hasSearched(true);
    }
  }
}
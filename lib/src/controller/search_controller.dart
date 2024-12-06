import 'package:get/get.dart';
import 'dart:developer';

import 'package:showbox/src/app_config/api_repo.dart';
import 'package:showbox/src/constant/constants.dart';

class SearchhController extends GetxController {
  late RxBool isMovieSearchLoading = false.obs;
  late RxBool isMoviePageSearchLoading = false.obs;
  late RxBool isSeriesSearchLoading = false.obs;
  late RxBool isSeriesPageSearchLoading = false.obs;
  late RxBool hasSearched = false.obs;
  late RxBool isAdult = false.obs;

  RxInt moviesPageNum = 1.obs;
  RxInt seriesPageNum = 1.obs;

  dynamic movieSearchList = [].obs;
  dynamic seriesSearchList = [].obs;

  @override
  void onInit() {
    super.onInit();
    hasSearched.value = false;
  }

  // Search Movies
  searchMovie(keyword) async {
    isMovieSearchLoading(true);
    movieSearchList.clear();
    try {
      var response = await ApiRepo.apiGet('${AppConstants.searchMovieUrl}?query=$keyword&include_adult=${isAdult.value}');
      if (response != null) {
        moviesPageNum.value = 1;
        movieSearchList = response["results"];
      }
    } catch (e) {
      log("errror in search $e");
    } finally {
      isMovieSearchLoading(false);
      hasSearched(true);
    }
  }

  // Search Movies Pagination
  getSearchMoviePagination(searchKeyword) async{
    try {
      moviesPageNum++;
      var response = await ApiRepo.apiGet("${AppConstants.searchMovieUrl}?query=$searchKeyword&page=$moviesPageNum&sort_by=popularity.desc&include_adult=${isAdult.value}");
      if(response != null) {
        movieSearchList.addAll(response['results']);
        if(response["page"] == response["total_pages"]){
          isMoviePageSearchLoading(false);
        }
      }
      else{
        isMoviePageSearchLoading(false);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // Search Series
  searchSeries(keyword) async {
    isSeriesSearchLoading(true);
    seriesSearchList.clear();
    try {
      var response = await ApiRepo.apiGet('${AppConstants.searchSeriesUrl}?query=$keyword&include_adult=${isAdult.value}', "");
      if (response != null) {
        seriesPageNum.value = 1;
        seriesSearchList = response["results"];
      }
    } catch (e) {
      log("errror in search $e");
    } finally {
      isSeriesSearchLoading(false);
      hasSearched(true);
    }
  }

  // Search Series Pagiantion
  getSearchSeriesPagination(searchKeyword) async{
    try {
      seriesPageNum++;
      var response = await ApiRepo.apiGet("${AppConstants.searchSeriesUrl}?query=$searchKeyword&page=$seriesPageNum&sort_by=popularity.desc&include_adult=${isAdult.value}");
      if(response != null) {
        seriesSearchList.addAll(response['results']);
        if(response["page"] == response["total_pages"]){
          isMoviePageSearchLoading(false);
        }
      }
      else{
        isMoviePageSearchLoading(false);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}


import 'dart:developer';
import 'package:get/get.dart';
import 'package:showbox/src/app_config/api_repo.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/models/series_details_model.dart';

class SeriesController extends GetxController{
  late RxBool isSeriesListLoading = false.obs;
  late RxBool isSeriesListPaginationLoading = false.obs;
  late RxBool isDetailLoading = false.obs;
  late RxBool isEpisodeLoading = false.obs;
  RxBool isTrendingSeriesLoading = false.obs;

  RxInt seriesListPage = 1.obs;
  RxBool showAdult = false.obs;

  var seriesList = <dynamic>[].obs;
  var trendingSeriesList = <dynamic>[].obs;
  dynamic episodeList = [];
  dynamic seriesDetail;

  // Initialize data
  void initialize() async {
    if (seriesList.isEmpty) {
      await getSeriesList();
    }
    if (trendingSeriesList.isEmpty) {
      await getTrendingSeriesList();
    }
  }

  // Get Trending Series
  getTrendingSeriesList() async {
    try {
      isTrendingSeriesLoading(true);
      var response = await ApiRepo.apiGet(AppConstants.trendingSeriesUrl, "");
      if(response != null) {
        trendingSeriesList.value = response['results'];
        isTrendingSeriesLoading( false);
      }
    } catch (e) {
      log('Error fetching trending movies: $e');
    } finally {
      isTrendingSeriesLoading(false);
    }
  }


  // Get Series List
  getSeriesList() async {
    try {
      isSeriesListLoading(true);
      var response = await ApiRepo.apiGet(AppConstants.showListUrl, "");
      if(response != null) {
        seriesList.value = response['results'];
        isSeriesListLoading(false);
      }
    } catch (e) {
      isSeriesListLoading(false);
    } finally{
      isSeriesListLoading(false);
    }
  }

  // Fetch next page for pagination
  fetchNextPage() async {  
    try {
      isSeriesListPaginationLoading(true);
      seriesListPage.value++;
      var response = await ApiRepo.apiGet(
        '${AppConstants.showListUrl}?page=${seriesListPage.value}&sort_by=popularity.desc&include_adult=$showAdult',
        "",
        "Get Series List Pagination",
      );
      if (response != null) {
        seriesList.addAll(response['results']);
        isSeriesListPaginationLoading(false);
      }
    } catch (e) {
      // Handle error
    } finally {
      isSeriesListPaginationLoading(false);
    }
  }


  //series detail
  getSeriesDetail(id) async{
    try {
      isDetailLoading(true);
      episodeList.clear();
      var response = await ApiRepo.apiGet("${AppConstants.showDetailUrl}/$id", "");
      if(response != null) {
        final allData = SeriesDetailModel.fromJson(response);
        seriesDetail = allData;
        isDetailLoading(false);
      }
    } catch (e) {
      log(e.toString());
    } finally{
      isDetailLoading(false);
    }
  }

  //getEpisodelist
  getEpisodeList(seriesId, seasonNo) async{
    try {
      isEpisodeLoading(true);
      episodeList.clear();
      var response = await ApiRepo.apiGet("${AppConstants.showDetailUrl}/$seriesId?api_key=${AppConstants.apiKey}&append_to_response=season/$seasonNo", "");
      if(response != null) {
        episodeList = response["season/$seasonNo"]["episodes"];
        isEpisodeLoading(false);
      }
    } catch (e) {
      log(e.toString());
    } finally{
      isEpisodeLoading(false);
    }
  }
}
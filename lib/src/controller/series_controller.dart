

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/app_config/api_repo.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/models/series_details_model.dart';
import 'package:showbox/src/models/top_rated_series_model.dart';

class SeriesController extends GetxController{
  late RxBool isSeriesListLoading = true.obs;
  late RxBool isSeriesListPaginationLoading = false.obs;
  late RxBool isDetailLoading = true.obs;
  late RxBool isEpisodeLoading = true.obs;
  RxBool isTrendingSeriesLoading = true.obs;
  late RxBool isTopRatedSeriesLoading = true.obs;

  late RxBool isScrollToTopVisible = false.obs; // Show Scroll To top

  RxInt seriesListPage = 1.obs;
  RxBool showAdult = true.obs;

  var seriesList = <dynamic>[].obs;
  var trendingSeriesList = <dynamic>[].obs;
   // Top Rated Series
  var topRatedSeries = [].obs;
  dynamic episodeList = [];
  dynamic seriesDetail;

  // Initialize data
  initialize({bool? isRefresh}) async {
    if (seriesList.isEmpty || isRefresh == true) {
      await getSeriesList();
    }
    if (trendingSeriesList.isEmpty || isRefresh == true) {
      await getTrendingSeriesList();
    }
    if (topRatedSeries.isEmpty || isRefresh == true) {
      await getTopRatedSeries();
    }
  }

  // Get Trending Series
  getTrendingSeriesList() async {
    try {
      isTrendingSeriesLoading(true);
      var response = await ApiRepo.apiGet(AppConstants.trendingSeriesUrl, "Trending Series");
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

  // Get Top Rated Series from API
  getTopRatedSeries() async {
    try {
      isTopRatedSeriesLoading(true);

      // Fetch data from the API
      var response = await ApiRepo.apiGet(
        'https://api.themoviedb.org/3/tv/top_rated',
        "Get Top Rated Series"
      );
      if (response != null) {
        topRatedSeries.value = (response['results'] as List)
          .map((item) => TopRatedSeriesModel.fromJson(item))
          .toList();
        isTopRatedSeriesLoading(false);
      }
    } catch (e) {
      isTopRatedSeriesLoading(false);
      debugPrint('Error fetching top rated series: $e');
    } finally {
      isTopRatedSeriesLoading(false);
    }
  }

  // Get Series List
  getSeriesList() async {
    try {
      isSeriesListLoading(true);
      var response = await ApiRepo.apiGet(AppConstants.showListUrl, "Get Series List");
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
      var response = await ApiRepo.apiGet("${AppConstants.showDetailUrl}/$id", "Series Details");
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
      var response = await ApiRepo.apiGet("${AppConstants.showDetailUrl}/$seriesId?api_key=${AppConstants.apiKey}&append_to_response=season/$seasonNo", "Get Episode List");
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


import 'dart:developer';
import 'package:get/get.dart';
import 'package:showbox/src/app_config/api_repo.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/models/series_details_model.dart';

class SeriesController extends GetxController{
  late RxBool isLoading = false.obs;
  late RxBool isPageLoading = false.obs;
  late RxBool isDetailLoading = false.obs;
  late RxBool isEpisodeLoading = false.obs;
  int pageNum = 0;
  dynamic seriesList = [];
  dynamic episodeList = [];
  dynamic seriesDetail;


  // Get Series List
  getSeriesList() async {
    try {
      isLoading(true);
      var response = await ApiRepo.apiGet(AppConstants.showListUrl, "");
      if(response != null) {
        seriesList = response['results'];
        isLoading(false);
      }
    } catch (e) {
      isLoading(false);
    } finally{
      isLoading(false);
    }
  }

  //series list pagination
  getPagination() async{
    try {
      isPageLoading(true);
      var response = await ApiRepo.apiGet("${AppConstants.showListUrl}?page=$pageNum&sort_by=popularity.desc&include_adult=true", "");
      if(response != null) {
        seriesList.addAll(response['results']);
        isPageLoading(false);
      }
    } catch (e) {
      log(e.toString());
    } finally{
      isPageLoading(false);
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
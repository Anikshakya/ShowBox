import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:showbox/src/app_config/api_repo.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/models/movie_details_model.dart';
import 'package:showbox/src/models/top_rated_movies_model.dart';

class MovieController extends GetxController {
  RxBool isMovieListLoading = true.obs;
  RxBool isMovieListPaginationLoading = false.obs;
  RxBool isMovieDetailsLoading = true.obs;
  RxBool isTrendingMoviesLoading = true.obs;
  late RxBool isTopRatedMoviesLoading = true.obs;

  late RxBool isScrollToTopVisible = false.obs; // Show Scroll To top

  RxInt movielistPage = 1.obs;
  RxBool showAdult = false.obs;

  var moviesList = <dynamic>[].obs;
  var trendingMovieList = <dynamic>[].obs;
  MovieDetails? movieDetails;
  // Top Rated Movies
  var topRatedMovies = [].obs;

  // Initialize data
  void initialize() async {
    if (moviesList.isEmpty) {
      await getMovieList();
    }
    if (trendingMovieList.isEmpty) {
      await getTrendingMoviesList();
    }
    if (topRatedMovies.isEmpty) {
      await getTopRatedMovies();
    }
  }

  // Get Trending Movies
  getTrendingMoviesList() async {
    try {
      isTrendingMoviesLoading(true);
      var response = await ApiRepo.apiGet(AppConstants.trendingMovieUrl, "");
      if(response != null) {
        trendingMovieList.value = response['results'];
        isTrendingMoviesLoading( false);
      }
    } catch (e) {
      log('Error fetching trending movies: $e');
    } finally {
      isTrendingMoviesLoading(false);
    }
  }

  // Get Top Rated Movies
  getTopRatedMovies() async {
    try {
      isTopRatedMoviesLoading(true);
      var response = await ApiRepo.apiGet(
        'https://api.themoviedb.org/3/movie/top_rated', 
        '', 
        'Get Top Rated Movies'
      );
      if (response != null) {
        topRatedMovies.value = (response['results'] as List)
            .map((item) => TopRatedMoviesModel.fromJson(item))
            .toList();
        isTopRatedMoviesLoading(false);
      }
    } catch (e) {
      debugPrint('Error fetching top rated movies: $e');
    } finally {
      isTopRatedMoviesLoading(false);
    }
  }

  // Fetch initial movie list
  getMovieList() async {
    try {
      isMovieListLoading(true);
      var response = await ApiRepo.apiGet(
        AppConstants.movieListUrl,
        "",
        "Get Movie List",
      );
      if (response != null) {
        movielistPage.value = 1;
        moviesList.value = response['results'];
      }
    } catch (e) {
      // Handle error
    } finally {
      isMovieListLoading(false);
    }
  }

  // Fetch next page for pagination
  fetchNextPage() async {
    try {
      isMovieListPaginationLoading(true);
      update();
      movielistPage.value++;
      var response = await ApiRepo.apiGet(
        '${AppConstants.movieListUrl}?page=${movielistPage.value}&sort_by=popularity.desc&include_adult=$showAdult',
        "",
        "Get Movie List Pagination",
      );
      if (response != null) {
        moviesList.addAll(response['results']);
        isMovieListPaginationLoading(false);
        update();
      }
    } catch (e) {
      // Handle error
    } finally {
      isMovieListPaginationLoading(false);
      update();
    }
  }

  // Get Movie Details
  getMovieDetails({required int id}) async {
    try {
      isMovieDetailsLoading(true);
      var response = await ApiRepo.apiGet(
        "${AppConstants.movieDetailUrl}/$id",
        "",
        "Get Movie Details",
      );
      if (response != null) {
        movieDetails = MovieDetails.fromJson(response);
        isMovieDetailsLoading(false);
      }
    } catch (e) {
      // Handle error
    } finally {
      isMovieDetailsLoading(false);
    }
  }
}

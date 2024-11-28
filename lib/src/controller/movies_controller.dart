import 'dart:developer';

import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:showbox/src/app_config/api_repo.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/models/movie_details_model.dart';

class MovieController extends GetxController {
  RxBool isMovieListLoading = false.obs;
  RxBool isMovieListPaginationLoading = false.obs;
  RxBool isMovieDetailsLoading = false.obs;
  RxBool isTrendingMoviesLoading = false.obs;

  RxInt movielistPage = 1.obs;
  RxBool showAdult = false.obs;

  var moviesList = <dynamic>[].obs;
  var trendingMovieList = <dynamic>[].obs;
  MovieDetails? movieDetails;  // Declare as Rx<Movie>

  // Initialize data
  void initialize() async {
    if (moviesList.isEmpty) {
      await getMovieList();
    }
    if (trendingMovieList.isEmpty) {
      await getTrendingMoviesList();
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

  // Fetch initial movie list
  Future<void> getMovieList() async {
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
  Future<void> fetchNextPage() async {
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

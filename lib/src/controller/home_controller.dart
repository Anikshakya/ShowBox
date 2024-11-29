  import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
  import 'package:showbox/src/app_config/api_repo.dart';
  import 'package:showbox/src/constant/constants.dart';
  import 'package:showbox/src/models/top_rated_movies_model.dart';
  import 'package:showbox/src/models/top_rated_series_model.dart';

  class HomeController extends GetxController{
    late RxBool isTrendingListLoading = true.obs;
    late RxBool isTopRatedMoviesLoading = true.obs;
    late RxBool isTopRatedSeriesLoading = true.obs;
    late RxBool isUpcommingMoviesLoding = true.obs;

    // Trending List
    var trendingList = [].obs;

    // Top Rated Movies
    var topRatedMovies = [].obs;

    // Top Rated Series
    var topRatedSeries = [].obs;

    // UpComming Movies
    var upcommingMovies = [].obs;

    // Initialize data
    void initialize() async {
      if (trendingList.isEmpty) {
        await getTrendingList();
      }
      if (upcommingMovies.isEmpty) {
        await getUpcommingMovies();
      }
      if (topRatedMovies.isEmpty) {
        await getTopRatedMovies();
      }
      if (topRatedSeries.isEmpty) {
        await getTopRatedSeries();
      }
    }

    // Get Trend List
    getTrendingList() async {
      try {
        isTrendingListLoading(true);
        var response = await ApiRepo.apiGet(AppConstants.trendingUrl, "", "Get Trending List");
        if(response != null) {
          trendingList.value = response['results'];
          isTrendingListLoading(false);
        }
      } catch (e) {
        isTrendingListLoading(false);
      } finally {
        isTrendingListLoading(false);
      }
    }

    // Get Upcomming Movies from API
    getUpcommingMovies() async {
      try {
        isUpcommingMoviesLoding(true);

        // Fetch data from the API
        var response = await ApiRepo.apiGet(
          'https://api.themoviedb.org/3/movie/popular?language=en-US&page=1',
          "",
          "Get Upcomming Movies"
        );
        if (response != null) {
          upcommingMovies.value = response['results'];
          isUpcommingMoviesLoding(false);
        }
      } catch (e) {
        isUpcommingMoviesLoding(false);
        debugPrint('Error fetching top rated series: $e');
      } finally {
        isUpcommingMoviesLoding(false);
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

    // Get Top Rated Series from API
    getTopRatedSeries() async {
      try {
        isTopRatedSeriesLoading(true);

        // Fetch data from the API
        var response = await ApiRepo.apiGet(
          'https://api.themoviedb.org/3/tv/top_rated',
          "",
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
  }
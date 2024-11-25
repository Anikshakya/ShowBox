import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:showbox/src/app_config/api_repo.dart';
import 'package:showbox/src/constant/constants.dart';

class MovieController extends GetxController {
  RxBool isMovieListLoading = false.obs;
  RxBool isMovieListPaginationLoading = false.obs;
  RxBool isMovieDetailsLoading = false.obs;

  RxInt movielistPage = 1.obs;
  RxBool showAdult = false.obs;

  var moviesList = <dynamic>[].obs;
  var movieDetails = {}.obs;

  // Initialize data
  void initialize() async {
    if (moviesList.isEmpty) {
      await getMovieList();
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
      movielistPage.value++;
      var response = await ApiRepo.apiGet(
        '${AppConstants.movieListUrl}?page=${movielistPage.value}&sort_by=popularity.desc&include_adult=$showAdult',
        "",
        "Get Movie List Pagination",
      );
      if (response != null) {
        moviesList.addAll(response['results']);
      }
    } catch (e) {
      // Handle error
    } finally {
      isMovieListPaginationLoading(false);
    }
  }

  // Get Movie Details
  getMovieDetails ({id}) async {
    try {
      isMovieDetailsLoading(true);
      var response = await ApiRepo.apiGet("${AppConstants.movieDetailUrl}/$id","","Get Movie Details",);
      if (response != null) {
        // Map and process the response
        movieDetails.value = {
          "title": response["title"],
          "tagline": response["tagline"],
          "overview": response["overview"],
          "genres": response["genres"].map((genre) => genre["name"]).toList(),
          "release_date": response["release_date"],
          "runtime": response["runtime"],
          "budget": response["budget"],
          "revenue": response["revenue"],
          "homepage": response["homepage"],
          "vote_average": response["vote_average"],
          "vote_count": response["vote_count"],
          "poster_url": "${AppConstants.posterUrl}${response['poster_path']}",
          "backdrop_url": "${AppConstants.posterUrl}${response['backdrop_path']}",
          "production_companies": response["production_companies"]
              .map((company) => company["name"])
              .toList(),
        };
      }
    } catch (e) {
      // Handle error
    } finally {
      isMovieDetailsLoading(false);
    }
  }
}

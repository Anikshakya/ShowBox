import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:showbox/src/app_config/api_repo.dart';
import 'package:showbox/src/constant/constants.dart';

class MovieController extends GetxController {
  RxBool isMovieListLoading = false.obs;
  RxBool isMovieListPaginationLoading = false.obs;

  RxInt movielistPage = 1.obs;
  RxBool showAdult = false.obs;

  var moviesList = <dynamic>[].obs;

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
}

import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:showbox/src/app_config/api_repo.dart';
import 'package:showbox/src/constant/constants.dart';

class MovieController extends GetxController{
  late RxBool isMovieListLoading = false.obs;
  late RxBool isMovieListPaginationLoading = false.obs;

  RxInt movielistPage = 0.obs;

  RxBool showAdult = false.obs;

  dynamic moviesList = [];

  // Get Movie List
  getMovieList() async {
    try {
      isMovieListLoading(true);
      var response = await ApiRepo.apiGet(AppConstants.movieListUrl, "", "Get Movie List");
      if(response != null) {
        moviesList = response['results'];
        isMovieListLoading(false);
      }
    } catch (e) {
      isMovieListLoading(false);
    } finally{
      isMovieListLoading(false);
    }
  }

  getMovieListPagination() async{
    try {
      isMovieListPaginationLoading(true);
      var response = await ApiRepo.apiGet('${AppConstants.movieListUrl}?page=$movielistPage&sort_by=popularity.desc&include_adult=$showAdult', "", "Get Movie List Pagination");
      if(response != null) {
        moviesList.addAll(response['results']);
        isMovieListPaginationLoading(false);
      }
    } catch (e) {
      isMovieListPaginationLoading(false);
    } finally{
      isMovieListPaginationLoading(false);
    }
  }
}
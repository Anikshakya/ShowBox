import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:showbox/src/app_config/api_repo.dart';
import 'package:showbox/src/constant/constants.dart';

class HomeController extends GetxController{
  late RxBool isLoading = false.obs;
  dynamic movieData = [];

   // Start Loading
  startLoading(){
    isLoading(true);
    update();
  }

  // Stop Loading
  stopLoading(){
    isLoading(false);
    update();
  }

  // Get Movie List
  getMovieList() async {
    try {
      startLoading();
      var response = await ApiRepo.apiGet(AppConstants.movieListUrl, "", "Get Movie List");
      if(response != null && response['code'] == 200) {
        stopLoading();
      }
    } catch (e) {
      stopLoading();
    } finally{
      stopLoading();
    }
  }
}
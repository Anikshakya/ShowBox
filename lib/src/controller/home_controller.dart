import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:showbox/src/app_config/api_repo.dart';
import 'package:showbox/src/constant/constants.dart';

class HomeController extends GetxController{
  late RxBool isTrendingListLoading = false.obs;

  // Trending List
  var trendingList = [].obs;

  // Initialize data
  void initialize() async {
    if (trendingList.isEmpty) {
      await getTrendingList();
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
}
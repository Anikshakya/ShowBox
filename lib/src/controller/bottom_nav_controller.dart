import 'package:flutter/rendering.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
class BottomNavController extends GetxController{
  late RxBool isNavVisible = true.obs;

  toggleBottomNavAccToScroll({scrollController}){
    // Add a listener to the ScrollController
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        // Scrolling down, hide the bottom nav
        if (isNavVisible.isTrue) {
            isNavVisible.value = false;
        }
      } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
        // Scrolling up, show the bottom nav
        if (!isNavVisible.isTrue) {
            isNavVisible.value = true;
        }
      }
    });
  }
}
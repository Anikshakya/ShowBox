import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  late RxBool isNavVisible = true.obs;
  late RxBool isAppbarVisible = true.obs;

  // Function to toggle bottom navigation visibility based on scroll direction
  toggleBottomNavAccToScroll({required ScrollController scrollController}) {
    // Add a listener to the ScrollController
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        // Scrolling down, hide the bottom nav
        if (isNavVisible.isTrue && isAppbarVisible.isTrue) {
          isNavVisible.value = false;
          isAppbarVisible.value = false;
        }
      } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
        // Scrolling up, show the bottom nav
        if (isNavVisible.isFalse && isAppbarVisible.isFalse) {
          isNavVisible.value = true;
          isAppbarVisible.value = true;
        }
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  // Reactive variables to control the visibility of the bottom navigation and app bar
  late RxBool isNavVisible = true.obs;
  late RxBool isAppbarVisible = true.obs;

  // Function to toggle bottom navigation visibility based on scroll direction
  toggleBottomNavAccToScroll({required ScrollController scrollController}) {
    // Add a listener to the ScrollController to detect scroll direction
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        // If scrolling down, hide the bottom nav and app bar
        if (isNavVisible.isTrue && isAppbarVisible.isTrue) {
          isNavVisible.value = false;
          isAppbarVisible.value = false;
        }
      } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
        // If scrolling up, show the bottom nav and app bar
        if (isNavVisible.isFalse && isAppbarVisible.isFalse) {
          isNavVisible.value = true;
          isAppbarVisible.value = true;
        }
      }
    });
  }
}

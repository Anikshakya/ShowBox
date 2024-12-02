import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/view/bottom_nav.dart';
import 'package:showbox/src/widgets/app_intro_animation.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 3860), () {
      Get.offAll(()=> const BottomNav());
    });

    return const Scaffold(
      body: Center(
        child: AppIntroAnimation(
          child: Text(
            'ShowBox',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

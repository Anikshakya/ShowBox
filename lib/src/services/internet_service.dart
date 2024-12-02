import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:showbox/src/view/no_internet_page.dart';
import 'package:showbox/src/view/splash_screen.dart';

class InternetService {
  late final StreamSubscription<bool> _internetSubscription;
  bool _lastKnownStatus = true;

  // Start monitoring internet connection
  void startMonitoring() {
    _internetSubscription = internetStatusStream.listen((isConnected) {
      if (isConnected != _lastKnownStatus) {
        _lastKnownStatus = isConnected;
        if (isConnected) {
          _returnToMainFlow();
        } else {
          _showNoInternetScreen();
        }
      }
    });
  }

  // Stop monitoring internet connection
  void stopMonitoring() {
    _internetSubscription.cancel();
  }

  // Stream to monitor internet connectivity
  Stream<bool> get internetStatusStream async* {
    while (true) {
      yield await _isInternetAvailable();
      await Future.delayed(const Duration(seconds: 4)); // Check every 4 seconds
    }
  }

  // Check internet availability
  Future<bool> _isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // Navigate to the no internet screen
  void _showNoInternetScreen() {
    if (!Get.isDialogOpen!) {
      Get.offAll(() => const NoInternetPage());
    }
  }

  // Navigate back to the main app flow
  void _returnToMainFlow() {
    Get.offAll(() => const SplashScreen());
  }
}
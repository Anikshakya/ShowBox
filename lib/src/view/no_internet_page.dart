import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/view/splash_screen.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("No Internet Connection"),
        automaticallyImplyLeading: false, // Prevent the back action
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.signal_wifi_off, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              'No internet connection!',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Check if the internet is available
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  Get.offAll(()=> const SplashScreen());
                } else {
                  // If no internet, stay on the page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Still no internet connection')),
                  );
                }
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}

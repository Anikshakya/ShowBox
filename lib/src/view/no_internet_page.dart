import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/view/splash_screen.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  bool _isLoading = false; // Track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon and message
              const Icon(
                Icons.signal_wifi_off,
                size: 120,
                color: Color(0XFFCBA84A),
              ),
              const SizedBox(height: 30),
              const Text(
                'Oops! No internet connection.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Please check your connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),

              // Retry Button with Loading
              TextButton(
                onPressed: _isLoading ? null : _retryConnection,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0XFFCBA84A), // Button background color
                  foregroundColor: Colors.white, // Text and icon color
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                ).copyWith(
                  overlayColor: WidgetStateProperty.all(Colors.transparent), // Remove blue focus
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        "Retry",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Retry Connection Function
  Future<void> _retryConnection() async {
    setState(() {
      _isLoading = true; // Show loading
    });

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Get.offAll(() => const SplashScreen()); // Navigate to SplashScreen
      } else {
        _showNoInternetSnackBar();
      }
    } catch (e) {
      _showNoInternetSnackBar();
    } finally {
      setState(() {
        _isLoading = false; // Hide loading
      });
    }
  }

  // Show SnackBar for no internet
  void _showNoInternetSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No internet connection. Please try again.'),
      ),
    );
  }
}
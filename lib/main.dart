import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showbox/src/app_config/theme/theme.dart';
import 'package:showbox/src/services/internet_service.dart';
import 'package:showbox/src/view/splash_screen.dart';

void main() async {
  // Ensure widget binding is initialized before calling setSystemUIOverlayStyle
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Initialize and start monitoring internet connection
  final internetService = InternetService();
  internetService.startMonitoring();

  runApp(
    GetMaterialApp(
      title: "ShowBox",
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: CAppTheme.lightTheme,
      darkTheme: CAppTheme.darkTheme,
      home: const SplashScreen(),                                                                                                                                                   
      builder: (context, child) {
        // Update the system UI based on the current theme
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Transparent status bar
          statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light, // Set the status bar icon color based on the theme
        ));
        return child!;
      },
    ),
  );
}
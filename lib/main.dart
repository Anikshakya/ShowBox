import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showbox/src/app_config/theme/theme.dart';
import 'package:showbox/src/services/internet_service.dart';
import 'package:showbox/src/view/splash_screen.dart';

void main() async {
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
    )
  );
}
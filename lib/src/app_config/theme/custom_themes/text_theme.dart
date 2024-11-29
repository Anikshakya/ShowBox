import 'package:flutter/material.dart';

class CTextTheme {
  CTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.w600, color: Colors.black), // Increased weight
    headlineMedium: const TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.w500, color: Colors.black), // Increased weight
    headlineSmall: const TextStyle().copyWith(fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.black), // Increased weight

    titleLarge: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black), // Increased weight
    titleMedium: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.black), // Increased weight
    titleSmall: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w300, color: Colors.black), // Increased weight

    bodyLarge: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.black), // Increased weight
    bodyMedium: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w300, color: Colors.black), // Increased weight
    bodySmall: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.black.withOpacity(0.5)), // Increased weight

    labelLarge: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.w300, color: Colors.black), // Increased weight
    labelMedium: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.w300, color: Colors.black.withOpacity(0.5)), // Increased weight
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.w600, color: Colors.white), // Increased weight
    headlineMedium: const TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.w500, color: Colors.white), // Increased weight
    headlineSmall: const TextStyle().copyWith(fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white), // Increased weight

    titleLarge: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white), // Increased weight
    titleMedium: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w400, color: Colors.white), // Increased weight
    titleSmall: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w300, color: Colors.white), // Increased weight

    bodyLarge: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.white), // Increased weight
    bodyMedium: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w300, color: Colors.white), // Increased weight
    bodySmall: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.5)), // Increased weight

    labelLarge: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.w300, color: Colors.white), // Increased weight
    labelMedium: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.w300, color: Colors.white.withOpacity(0.5)), // Increased weight
  );
}
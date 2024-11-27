import 'package:flutter/material.dart';
import 'package:showbox/src/app_config/theme/custom_themes/appbar_theme.dart';
import 'package:showbox/src/app_config/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:showbox/src/app_config/theme/custom_themes/check_box_theme.dart';
import 'package:showbox/src/app_config/theme/custom_themes/elevated_button_theme.dart';
import 'package:showbox/src/app_config/theme/custom_themes/outlined_button_theme.dart';
import 'package:showbox/src/app_config/theme/custom_themes/text_theme.dart';
import 'package:showbox/src/app_config/theme/custom_themes/textfield_theme.dart';

class CAppTheme {
  CAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    textTheme: CTextTheme.lightTextTheme,
    elevatedButtonTheme: CElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: CAppBarTheme.lightAppBarTheme,
    checkboxTheme: CCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: CBottomSheetTheme.lightBottomSheetTheme,
    outlinedButtonTheme: COutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: CTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.black,
    textTheme: CTextTheme.darkTextTheme,
    elevatedButtonTheme: CElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: CAppBarTheme.darkAppBarTheme,
    checkboxTheme: CCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: CBottomSheetTheme.darkBottomSheetTheme,
    outlinedButtonTheme: COutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: CTextFormFieldTheme.darkInputDecorationTheme,
  );
}

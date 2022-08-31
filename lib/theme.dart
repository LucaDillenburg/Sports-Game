import 'package:flutter/material.dart';

final appColors = AppColors(
  primary: Color(0xfffe5944),
  secondary: Color(0xfffdd20d),
  tertiary: Color(0xff02a6e7),
);

class AppColors {
  final Color primary;
  final Color secondary;
  final Color tertiary;

  AppColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
  });

  static AppColors of(BuildContext context) {
    return appColors;
  }
}

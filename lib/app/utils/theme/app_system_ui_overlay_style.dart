import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_time_chat/app/utils/theme/app_colors.dart';

class DarkSystemUiOverlayStyle extends AnnotatedRegion<SystemUiOverlayStyle> {
  const DarkSystemUiOverlayStyle({super.key, required super.child, super.value = style});

  static const style = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: KColors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: KColors.bg,
  );

  static const style2 = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarColor: KColors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: KColors.bg,
  );
}

class SplashSystemUiOverlayStyle extends AnnotatedRegion<SystemUiOverlayStyle> {
  const SplashSystemUiOverlayStyle({super.key, required super.child, super.value = style});

  static const style = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: KColors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: KColors.bg,
    systemNavigationBarDividerColor: KColors.transparent,
  );
}

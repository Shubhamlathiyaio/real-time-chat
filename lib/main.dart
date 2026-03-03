import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_time_chat/app/routes/app_pages.dart';
import 'package:real_time_chat/app/routes/app_routes.dart';
import 'package:real_time_chat/app/utils/helpers/injectable/injectable.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

const String _kAppName = 'Real Time Chat';

void main() => configureServices(myApp: MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      theme: ShadThemeData(brightness: Brightness.light, colorScheme: const ShadSlateColorScheme.light()),
      darkTheme: ShadThemeData(brightness: Brightness.dark, colorScheme: const ShadSlateColorScheme.dark()),
      home: GetMaterialApp(debugShowCheckedModeBanner: false, title: _kAppName, getPages: AppPages.routes, initialRoute: AppRoutes.splash),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../routes/app_routes.dart';

@lazySingleton
class AppController extends GetxController {
  void onSplash(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        Get.offAllNamed(AppRoutes.base);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:real_time_chat/app/routes/app_routes.dart';

@lazySingleton
class AppController extends GetxController {
  final _completer = Completer<bool>();
  Future<void> onSplash(BuildContext context) async {
    Future.delayed(const Duration(seconds: 3), () async {
      if (await _completer.future) _routeTo();
    });

    // await _preference.getToken();
    _completer.complete(true);
  }

  Future<void> _routeTo() async {
    if (FirebaseAuth.instance.currentUser != null) {
      Get.offAllNamed(AppRoutes.base);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}

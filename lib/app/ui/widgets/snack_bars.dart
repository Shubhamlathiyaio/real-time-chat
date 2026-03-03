import 'package:flutter/material.dart';

GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();

class Snack {
  static void showBar(String message) {
    snackBarKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }
}



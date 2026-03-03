import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:real_time_chat/app/utils/helpers/injectable/injectable.config.dart';

final getIt = GetIt.instance;

@i.injectableInit
void configureServices({required Widget myApp}) {
  _init(myApp);
  return;
}

Future<void> _init(Widget myApp) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getIt.init();
  runApp(myApp);
}

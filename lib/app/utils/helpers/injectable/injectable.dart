import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' as i;
import 'package:real_time_chat/app/utils/helpers/injectable/injectable.config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

@i.injectableInit
void configureServices({required Widget myApp}) {
  _init(myApp);
  return;
}

Future<void> _init(Widget myApp) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: 'https://mojjxzmkygraysviphjw.supabase.co', anonKey: 'sb_publishable_6Hshl4MCfUeIBrhjj3mI2A_GhRUKYli');
  getIt.init();
  runApp(myApp);
}

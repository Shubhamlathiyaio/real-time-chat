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
  await Supabase.initialize(
    url: 'https://mojjxzmkygraysviphjw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1vamp4em1reWdyYXlzdmlwaGp3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI1NTkxMDQsImV4cCI6MjA4ODEzNTEwNH0.lTzL6vgg3r-vKrMUgd13MlOKy0mwsmWHew46FxBE2ag',
  );
  getIt.init();
  runApp(myApp);
}

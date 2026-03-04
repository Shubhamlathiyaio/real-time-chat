import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:real_time_chat/app/routes/app_routes.dart';
import 'package:real_time_chat/app/utils/helpers/extensions/preference.dart';
import 'package:real_time_chat/app/utils/helpers/injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class AuthController extends GetxController {
  void logout() {
    getIt<SharedPreferences>().removeAll();
    Get.offAllNamed(AppRoutes.login);
  }
}

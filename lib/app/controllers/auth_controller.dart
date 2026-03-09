import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:real_time_chat/app/data/services/auth_service.dart';
import 'package:real_time_chat/app/routes/app_routes.dart';
import 'package:real_time_chat/app/utils/helpers/extensions/preference.dart';
import 'package:real_time_chat/app/utils/helpers/injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class AuthController extends GetxController {
  final _auth = getIt<AuthService>();
  final isLoading = false.obs;
  final error = RxnString();

  Future<void> initiateAuth(String email, String password) async {
    isLoading.value = true;
    error.value = null;

    try {
      // Try login first, then signup
      var user = await _auth.logIn(email.trim(), password);
      user ??= await _auth.signUp(email.trim(), password);

      if (user != null) {
        getIt<SharedPreferences>().setBool('isLoggedIn', true);
        Get.offAllNamed(AppRoutes.chat);
      } else {
        error.value = 'Invalid credentials. Please try again.';
      }
    } catch (e) {
      error.value = 'An unexpected error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    getIt<SharedPreferences>().removeAll();
    getIt<AuthService>().logOut();
    Get.offAllNamed(AppRoutes.login);
  }
}

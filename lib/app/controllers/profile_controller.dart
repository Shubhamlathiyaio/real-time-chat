import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:real_time_chat/app/data/services/auth_service.dart';
import 'package:real_time_chat/app/routes/app_routes.dart';
import 'package:real_time_chat/app/utils/helpers/injectable/injectable.dart';
import 'package:real_time_chat/app/utils/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final _auth = getIt<AuthService>();

  User? get user => FirebaseAuth.instance.currentUser;

  RxString get displayName => (user?.displayName?.isNotEmpty == true ? user!.displayName! : user?.email?.split('@').first ?? 'User').obs;

  RxString get email => (user?.email ?? 'No email').obs;

  String get initials {
    final name = displayName;
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name.value[0].toUpperCase() : '?';
  }

  final RxBool isLoggingOut = false.obs;

  Future<void> logout() async {
    isLoggingOut.value = true;
    try {
      await _auth.logOut();
      getIt<SharedPreferences>().clear();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      isLoggingOut.value = false;
      Get.snackbar('Error', 'Failed to log out. Please try again.', backgroundColor: KColors.border, colorText: KColors.white);
    }
  }
}

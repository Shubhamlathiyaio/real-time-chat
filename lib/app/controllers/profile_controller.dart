import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/services/auth_service.dart';
import '../routes/app_routes.dart';
import '../utils/helpers/injectable/injectable.dart';

class ProfileController extends GetxController {
  final RxBool isLoggingOut = false.obs;

  User? get user => Supabase.instance.client.auth.currentUser;
  String get email => user?.email ?? 'No email';
  String get displayName => user?.userMetadata?['display_name'] ?? user?.email?.split('@').first ?? 'User';

  String get initials {
    final name = displayName;
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Future<void> logout() async {
    isLoggingOut.value = true;
    try {
      await getIt<AuthService>().logOut();
      await getIt<SharedPreferences>().clear();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      isLoggingOut.value = false;
      Get.snackbar('Error', 'Failed to sign out. Try again.');
    }
  }
}

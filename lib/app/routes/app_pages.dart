import 'package:get/get.dart';
import 'package:real_time_chat/app/bindings/chat_details_binding.dart';
import 'package:real_time_chat/app/routes/app_routes.dart';
import 'package:real_time_chat/app/ui/screens/auth/login_screen.dart';
import 'package:real_time_chat/app/ui/screens/auth/splash_screen.dart';
import 'package:real_time_chat/app/ui/screens/base/demo.dart';
import 'package:real_time_chat/app/ui/screens/base/nav_bar.dart';
import 'package:real_time_chat/app/ui/screens/chat/chat_details_screen.dart';
import 'package:real_time_chat/app/ui/screens/home/chat_screen.dart';
import 'package:real_time_chat/app/ui/screens/home/users_screen.dart';
import 'package:real_time_chat/app/ui/screens/profile/profile_page.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.base, page: () => const NavBar()),
    GetPage(name: AppRoutes.chat, page: () => const ChatScreen()),
    GetPage(name: AppRoutes.chatDetails, page: () => const ChatDetailsScreen(), binding: ChatDetailsBinding()),
    GetPage(name: AppRoutes.profile, page: () => const ProfilePage()),
    GetPage(name: AppRoutes.users, page: () => const UsersScreen()),
    GetPage(name: AppRoutes.demo, page: () => const Demo()),
  ];
}

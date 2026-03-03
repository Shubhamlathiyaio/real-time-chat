import 'package:get/get.dart';
import 'package:real_time_chat/app/routes/app_routes.dart';
import 'package:real_time_chat/app/ui/screens/auth/login_screen.dart';
import 'package:real_time_chat/app/ui/screens/auth/splash_screen.dart';
import 'package:real_time_chat/app/ui/screens/base/demo.dart';
import 'package:real_time_chat/app/ui/screens/base/nav_bar.dart';
import 'package:real_time_chat/app/ui/screens/home/home_screen.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.base, page: () => const NavBar()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
    GetPage(name: AppRoutes.demo, page: () => const Demo()),
  ];
}

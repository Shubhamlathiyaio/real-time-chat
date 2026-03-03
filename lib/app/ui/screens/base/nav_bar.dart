import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_time_chat/app/controllers/nav_bar_controller.dart';
import 'package:real_time_chat/app/services/extensions/context.dart';
import 'package:real_time_chat/app/ui/screens/base/demo.dart';
import 'package:real_time_chat/app/ui/screens/home/home_screen.dart';
import 'package:real_time_chat/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:real_time_chat/app/utils/helpers/injectable/injectable.dart';
import 'package:real_time_chat/app/utils/theme/app_system_ui_overlay_style.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends GetItHookState<NavBarController, NavBar> {
  @override
  Widget build(BuildContext context) {
    const notchHeight = 60.0;
    const notchWidth = 60.0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.back();
      },
      child: Obx(
        () => DarkSystemUiOverlayStyle(
          child: Scaffold(
            backgroundColor: Colors.transparent, // TODO: replace with aproprite theme color

            body: switch (controller.selectedIndex) {
              0 => const HomeScreen(),
              1 => const Demo(),
              2 => const Demo(),
              3 => const Demo(),
              _ => const SizedBox.shrink(),
            },
            bottomNavigationBar: SafeArea(
              child: IntrinsicHeight(
                child: Container(
                  height: notchHeight,
                  width: notchWidth,
                  padding: const .only(bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.transparent, // TODO: Replace with aproprite theme color
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.changeOpacity(0.1),
                        blurRadius: 10, // TODO: Replace with aproprite theme color
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children:
                        [
                              /*
                           (Icons.chat_bubble_rounded, Icons.chat_bubble_outline_rounded, 'Chats'),
      (Icons.group_rounded, Icons.group_outlined, 'Groups'),
      (Icons.call_rounded, Icons.call_outlined, 'Calls'),
      (Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
      */

                              // TODO: Change the labels and icons as per the requirement
                              (index: 0, icon: Icons.chat_bubble_rounded, fillIcon: Icons.chat_bubble_rounded, label: 'Chats'),
                              (index: 1, icon: Icons.group_rounded, fillIcon: Icons.group_rounded, label: 'Groups'),
                              (index: 2, icon: Icons.call_rounded, fillIcon: Icons.call_rounded, label: 'Calls'),
                              (index: 3, icon: Icons.person_rounded, fillIcon: Icons.person_rounded, label: 'Profile'),
                            ]
                            .map(
                              (e) => Expanded(
                                child: NavItem(index: e.index, icon: e.icon, fillIcon: e.fillIcon, label: e.label),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get autoDispose => true;
}

class NavItem extends StatelessWidget {
  const NavItem({super.key, required this.index, required this.icon, required this.fillIcon, required this.label});

  final int index;
  final IconData icon;
  final IconData fillIcon;
  final String label;
 
  @override
  Widget build(BuildContext context) {
    // Build the ui as per the design and theme
    return GestureDetector(
      onTap: () {
        getIt<NavBarController>().selectedIndex = index;
      },
      child: Column(children: [Icon(icon), Text(label)]),
    );
  }
}

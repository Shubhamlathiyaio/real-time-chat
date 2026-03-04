import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_time_chat/app/controllers/nav_bar_controller.dart';
import 'package:real_time_chat/app/ui/screens/base/demo.dart';
import 'package:real_time_chat/app/ui/screens/home/chat_screen.dart';
import 'package:real_time_chat/app/ui/screens/profile/profile_page.dart';
import 'package:real_time_chat/app/utils/helpers/extensions/context.dart';
import 'package:real_time_chat/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:real_time_chat/app/utils/helpers/injectable/injectable.dart';
import 'package:real_time_chat/app/utils/theme/app_colors.dart';
import 'package:real_time_chat/app/utils/theme/app_system_ui_overlay_style.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
            backgroundColor: KColors.bg,

            body: switch (controller.selectedIndex) {
              0 => const ChatScreen(),
              1 => const Demo(),
              2 => const Demo(),
              3 => const ProfilePage(),
              _ => const SizedBox.shrink(),
            },
            bottomNavigationBar: SafeArea(
              child: IntrinsicHeight(
                child: Container(
                  height: notchHeight,
                  width: notchWidth,
                  padding: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: ShadTheme.of(context).colorScheme.card,
                    boxShadow: [BoxShadow(color: Colors.black.changeOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
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
                                child: NavItem(index: e.index, icon: e.icon, fillIcon: e.fillIcon, label: e.label, isSelected: controller.selectedIndex == e.index),
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
  const NavItem({super.key, required this.index, required this.icon, required this.fillIcon, required this.label, required this.isSelected});

  final int index;
  final IconData icon;
  final IconData fillIcon;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        getIt<NavBarController>().selectedIndex = index;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(color: isSelected ? theme.colorScheme.primary.changeOpacity(0.12) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
            child: Icon(isSelected ? fillIcon : icon, color: isSelected ? theme.colorScheme.primary : theme.colorScheme.mutedForeground, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.muted.copyWith(
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.mutedForeground,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

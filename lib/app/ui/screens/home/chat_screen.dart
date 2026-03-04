import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_time_chat/app/controllers/chat_controller.dart';
import 'package:real_time_chat/app/data/models/chat_contact.dart';
import 'package:real_time_chat/app/data/services/chat_service.dart';
import 'package:real_time_chat/app/routes/app_routes.dart';
import 'package:real_time_chat/app/ui/widgets/app_scaffold.dart';
import 'package:real_time_chat/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:real_time_chat/app/utils/helpers/injectable/injectable.dart';
import 'package:real_time_chat/app/utils/theme/app_colors.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'widgets/chat_tile.dart';
import 'widgets/story_avatar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends GetItHookState<ChatController, ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return AppScaffold(
      backgroundColor: KColors.bg,
      titleWidget: _buildTopBar(theme),
      body: (context) => SafeArea(
        child: Column(
          children: [
            // _buildSearchBar(theme),
            SearchBar(),
            _buildStoriesRow(theme),
            _buildSectionHeader(theme),
            Expanded(
              child: ChatList(),
              // _buildChatList(theme)
            ),
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomNav(theme),
      floatingActionButton: _buildFAB(theme),
    );
  }

  // ── Top Bar ──────────────────────────────────
  Widget _buildTopBar(ShadThemeData theme) {
    return Row(
      children: [
        Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Text(
              'Messages',
              style: theme.textTheme.h2.copyWith(color: KColors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.8),
            ),
            Text(
              'Active chats',
              style: theme.textTheme.muted.copyWith(color: KColors.primary, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const Spacer(),
        _buildMyAvatar(),
      ],
    );
  }

  Widget _buildMyAvatar() {
    final popoverCtrl = ShadPopoverController();
    return
    // SizedBox(
    //   width: 44,
    //   height: 44,
    //   child: ShadPopover(
    //     controller: popoverCtrl,
    //     child: ShadButton.outline(child: Text("Click me! 📌")),
    //     popover: (context) => Padding(
    //       padding: const EdgeInsets.all(16),
    //       child: Column(
    //         mainAxisSize: .min,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text("Hello! 👋", style: ShadTheme.of(context).textTheme.h4),
    //           const SizedBox(height: 8),
    //           Text("This is your popover content."),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    ShadPopover(
      controller: popoverCtrl,

      popover: (context) => Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile Settings', style: ShadTheme.of(context).textTheme.large),
            const SizedBox(height: 8),
            ShadButton.ghost(
              onPressed: () {
                // controller.logout();
              },
              child: const Row(children: [Icon(Icons.logout, size: 16), SizedBox(width: 8), Text('Logout')]),
            ),
          ],
        ),
      ),
      child: Stack(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [KColors.primary, KColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
              border: Border.all(color: KColors.border, width: 2),
            ),
            child: const Center(
              child: Text(
                'ME',
                style: TextStyle(color: KColors.white, fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ),
          Positioned(
            bottom: 1,
            right: 1,
            child: Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: KColors.accent,
                shape: BoxShape.circle,
                border: Border.all(color: KColors.bg, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stories Row ──────────────────────────────
  Widget _buildStoriesRow(ShadThemeData theme) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: storiesData.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) return _buildAddStory();
          final s = storiesData[i - 1];
          return StoryAvatar(contact: s);
        },
      ),
    );
  }

  Widget _buildAddStory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: KColors.surfaceLight,
              border: Border.all(color: KColors.borderAlt, width: 1.5),
            ),
            child: const Icon(Icons.add_rounded, color: KColors.primary, size: 26),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add',
            style: TextStyle(color: KColors.muted, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ── Section Header ───────────────────────────
  Widget _buildSectionHeader(ShadThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        children: [
          Text(
            'Recent',
            style: theme.textTheme.small.copyWith(color: KColors.muted, fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 12),
          ),
          const Spacer(),
          ShadButton.ghost(
            onPressed: () => Get.toNamed(AppRoutes.users),
            size: ShadButtonSize.sm,
            child: const Text(
              'See all',
              style: TextStyle(color: KColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ── FAB ──────────────────────────────────────
  Widget _buildFAB(ShadThemeData theme) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [KColors.primary, KColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: KColors.primary.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.toNamed(AppRoutes.users),
          child: const Icon(Icons.edit_rounded, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  @override
  bool get autoDispose => true;
}

class SearchBar extends StatelessWidget {
  SearchBar({super.key});
  final controller = getIt<ChatController>();
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: KColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: KColors.borderAlt, width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search_rounded, color: KColors.mutedDark, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => controller.searchQuery.value = v,
                style: const TextStyle(color: KColors.white, fontSize: 15, fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: TextStyle(color: KColors.mutedDark, fontSize: 15),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (controller.searchQuery.value.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchCtrl.clear();
                  controller.searchQuery.value = '';
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.close_rounded, color: KColors.mutedDark, size: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  ChatList({super.key});
  final controller = getIt<ChatController>();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return StreamBuilder<List<ChatContact>>(
      stream: getIt<ChatService>().chatsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final chats = snapshot.data ?? [];

        return Obx(() {
          final query = controller.searchQuery.value.toLowerCase();
          final filtered = chats.where((c) => c.name.toLowerCase().contains(query) || c.lastMessage.toLowerCase().contains(query)).toList();

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: .min,
                children: [
                  const Icon(Icons.search_off_rounded, color: Color(0xFF2D2D45), size: 52),
                  const SizedBox(height: 12),
                  Text(query.isEmpty ? 'No conversations yet' : 'No results for "${controller.searchQuery.value}"', style: theme.textTheme.muted.copyWith(color: const Color(0xFF4B4B6A))),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: filtered.length,
            itemBuilder: (context, i) => ChatTile(contact: filtered[i]),
          );
        });
      },
    );
  }
}

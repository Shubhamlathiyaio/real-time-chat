import 'package:flutter/material.dart';
import 'package:real_time_chat/app/controllers/auth_controller.dart';
import 'package:real_time_chat/app/data/models/chat_contact.dart';
import 'package:real_time_chat/app/services/extensions/context.dart';
import 'package:real_time_chat/app/ui/widgets/app_scaffold.dart';
import 'package:real_time_chat/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'widgets/chat_tile.dart';
import 'widgets/story_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends GetItHookState<AuthController, HomeScreen> {
  int _selectedTab = 0;
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ChatContact> get _filteredChats =>
      chatsData.where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()) || c.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return AppScaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      titleWidget: _buildTopBar(theme),
      body: (context) => SafeArea(
        child: Column(
          children: [
            _buildSearchBar(theme),
            _buildStoriesRow(theme),
            _buildSectionHeader(theme),
            Expanded(child: _buildChatList(theme)),
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
              style: theme.textTheme.h2.copyWith(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.8),
            ),
            Text(
              '${chatsData.where((c) => c.unreadCount > 0).length} unread',
              style: theme.textTheme.muted.copyWith(color: const Color(0xFF6366F1), fontSize: 13, fontWeight: FontWeight.w500),
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
    //         mainAxisSize: MainAxisSize.min,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile Settings', style: ShadTheme.of(context).textTheme.large),
            const SizedBox(height: 8),
            ShadButton.ghost(
              onPressed: () {
                controller.logout();
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
              gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              border: Border.all(color: const Color(0xFF1E1E2E), width: 2),
            ),
            child: const Center(
              child: Text(
                'ME',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
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
                color: const Color(0xFF10B981),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0A0A0F), width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search Bar ───────────────────────────────
  Widget _buildSearchBar(ShadThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFF13131F),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E1E30), width: 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search_rounded, color: Color(0xFF4B4B6A), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: TextStyle(color: Color(0xFF4B4B6A), fontSize: 15),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchCtrl.clear();
                  setState(() => _searchQuery = '');
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.close_rounded, color: Color(0xFF4B4B6A), size: 18),
                ),
              ),
          ],
        ),
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
              color: const Color(0xFF13131F),
              border: Border.all(color: const Color(0xFF1E1E30), width: 1.5),
            ),
            child: const Icon(Icons.add_rounded, color: Color(0xFF6366F1), size: 26),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add',
            style: TextStyle(color: Color(0xFF6B6B8A), fontSize: 11, fontWeight: FontWeight.w500),
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
            style: theme.textTheme.small.copyWith(color: const Color(0xFF6B6B8A), fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 12),
          ),
          const Spacer(),
          ShadButton.ghost(
            onPressed: () {},
            size: ShadButtonSize.sm,
            child: const Text(
              'See all',
              style: TextStyle(color: Color(0xFF6366F1), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ── Chat List ────────────────────────────────
  Widget _buildChatList(ShadThemeData theme) {
    final chats = _filteredChats;

    if (chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, color: Color(0xFF2D2D45), size: 52),
            const SizedBox(height: 12),
            Text('No results for "$_searchQuery"', style: theme.textTheme.muted.copyWith(color: const Color(0xFF4B4B6A))),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: chats.length,
      itemBuilder: (context, i) => ChatTile(contact: chats[i]),
    );
  }

  // ── Bottom Nav ───────────────────────────────
  Widget _buildBottomNav(ShadThemeData theme) {
    final items = [
      (Icons.chat_bubble_rounded, Icons.chat_bubble_outline_rounded, 'Chats'),
      (Icons.group_rounded, Icons.group_outlined, 'Groups'),
      (Icons.call_rounded, Icons.call_outlined, 'Calls'),
      (Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D18),
        border: Border(top: BorderSide(color: Color(0xFF1A1A2E), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (i) {
              final isSelected = _selectedTab == i;
              final item = items[i];
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _selectedTab = i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(color: isSelected ? const Color(0xFF6366F1).changeOpacity(0.12) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
                        child: Icon(isSelected ? item.$1 : item.$2, color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF4B4B6A), size: 22),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
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
        gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: const Icon(Icons.edit_rounded, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  @override
  bool get autoDispose => true;
}

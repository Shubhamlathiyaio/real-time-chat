import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_time_chat/app/data/services/chat_service.dart';
import 'package:real_time_chat/app/routes/app_routes.dart';
import 'package:real_time_chat/app/utils/helpers/injectable/injectable.dart';
import 'package:real_time_chat/app/utils/theme/app_colors.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _chatService = getIt<ChatService>();
  final _currentUid = Supabase.instance.client.auth.currentUser?.id ?? '';
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await _chatService.getAllUsers(_currentUid);
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Failed to fetch users: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Scaffold(
      backgroundColor: KColors.bg,
      floatingActionButton: ShadButton(onPressed: () => Get.toNamed(AppRoutes.users), child: const Text('New Chat')),
      appBar: AppBar(
        backgroundColor: KColors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: KColors.muted, size: 20),
        ),
        title: Text('New Chat', style: theme.textTheme.h4.copyWith(color: KColors.white, letterSpacing: -0.5)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return _UserTile(user: user);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.people_outline_rounded, color: KColors.mutedDark, size: 64),
          const SizedBox(height: 16),
          const Text(
            'No other users found',
            style: TextStyle(color: KColors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text('Invite your friends to start chatting!', style: TextStyle(color: KColors.muted, fontSize: 14)),
        ],
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user});
  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    final name = user['display_name'] ?? user['email'] ?? 'Unknown';
    final initials = name.toString().substring(0, 1).toUpperCase();

    return ListTile(
      onTap: () {
        Get.toNamed(AppRoutes.chatDetails, arguments: {'otherUid': user['id'], 'otherName': name, 'otherAvatarUrl': user['avatar_url'], 'avatarColor': KColors.primary, 'isGroup': false});
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: KColors.primary.withOpacity(0.1),
        backgroundImage: user['avatar_url'] != null ? NetworkImage(user['avatar_url']) : null,
        child: user['avatar_url'] == null
            ? Text(
                initials,
                style: const TextStyle(color: KColors.primary, fontWeight: FontWeight.w700),
              )
            : null,
      ),
      title: Text(
        name,
        style: const TextStyle(color: KColors.white, fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(user['email'] ?? '', style: const TextStyle(color: KColors.muted, fontSize: 13)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: KColors.mutedDark, size: 14),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:real_time_chat/app/controllers/chat_details_controller.dart';
import 'package:real_time_chat/app/data/models/message.dart';
import 'package:real_time_chat/app/utils/theme/app_colors.dart';

class ChatDetailsScreen extends GetView<ChatDetailsController> {
  const ChatDetailsScreen({super.key});

  String get _currentUid => FirebaseAuth.instance.currentUser?.uid ?? 'current_user_id';

  @override
  Widget build(BuildContext context) {
    final otherName = Get.arguments['otherName'] as String? ?? 'Chat';
    final otherAvatarUrl = Get.arguments['otherAvatarUrl'] as String?;
    final avatarColor = Get.arguments['avatarColor'] as Color? ?? KColors.primary;
    final isGroup = Get.arguments['isGroup'] as bool? ?? false;

    return Scaffold(
      backgroundColor: KColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, otherName, otherAvatarUrl, avatarColor, isGroup),
            Expanded(child: Stack(children: [_buildMessageList(avatarColor, otherName), Obx(() => controller.showScrollDown.value ? _buildScrollDownButton() : const SizedBox.shrink())])),
            Obx(() => controller.replyingToText.value != null ? _buildReplyBanner() : const SizedBox.shrink()),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────
  Widget _buildAppBar(BuildContext context, String name, String? avatarUrl, Color avatarColor, bool isGroup) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 8, 12, 8),
      decoration: const BoxDecoration(
        color: KColors.surface,
        border: Border(bottom: BorderSide(color: KColors.borderLight, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: KColors.muted, size: 20),
          ),
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: avatarColor,
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child: avatarUrl == null
                    ? Text(
                        isGroup ? '👥' : _getInitials(name),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                      )
                    : null,
              ),
              if (!isGroup)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: KColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: KColors.surface, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15.5, letterSpacing: -0.3),
                ),
                const SizedBox(height: 1),
                Text(
                  isGroup ? 'Tap for group info' : 'Online',
                  style: const TextStyle(color: KColors.accent, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam_rounded, color: KColors.muted, size: 22),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call_rounded, color: KColors.muted, size: 20),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded, color: KColors.muted, size: 22),
          ),
        ],
      ),
    );
  }

  // ── Message List ──────────────────────────────
  Widget _buildMessageList(Color avatarColor, String otherName) {
    return Obx(() {
      final messages = controller.messages;

      if (messages.isEmpty) {
        return _buildEmptyState(avatarColor, otherName);
      }

      return ListView.builder(
        controller: controller.scrollCtrl,
        reverse: true,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          final isMe = msg.senderId == _currentUid;

          final showDate = index == messages.length - 1 || !_isSameDay(msg.timestamp, messages[index + 1].timestamp);

          final isFirstInGroup = index == 0 || messages[index - 1].senderId != msg.senderId || msg.timestamp.difference(messages[index - 1].timestamp).inMinutes > 3;

          return Column(
            children: [
              if (showDate) _buildDateSeparator(msg.timestamp),
              _MessageBubble(
                message: msg,
                isMe: isMe,
                isFirstInGroup: isFirstInGroup,
                senderInitial: isMe ? 'ME' : _getInitials(otherName),
                avatarColor: isMe ? KColors.primary : avatarColor,
                onLongPress: () => _showMessageOptions(context, msg),
                onSwipe: () => controller.setReplyingTo(msg.text),
              ),
            ],
          );
        },
      );
    });
  }

  Widget _buildEmptyState(Color avatarColor, String name) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(shape: BoxShape.circle, color: avatarColor.withOpacity(0.12)),
            child: Center(
              child: Text(
                _getInitials(name),
                style: TextStyle(color: avatarColor, fontWeight: FontWeight.w800, fontSize: 26),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'No messages yet.\nSay hello! 👋',
            textAlign: TextAlign.center,
            style: TextStyle(color: KColors.muted, fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(DateTime dt) {
    final now = DateTime.now();
    String label;
    if (_isSameDay(dt, now)) {
      label = 'Today';
    } else if (_isSameDay(dt, now.subtract(const Duration(days: 1)))) {
      label = 'Yesterday';
    } else {
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      label = '${months[dt.month - 1]} ${dt.day}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider(color: KColors.borderLight, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: const TextStyle(color: KColors.mutedDark, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
            ),
          ),
          const Expanded(child: Divider(color: KColors.borderLight, thickness: 1)),
        ],
      ),
    );
  }

  // ── Scroll Down FAB ───────────────────────────
  Widget _buildScrollDownButton() {
    return Positioned(
      bottom: 12,
      right: 16,
      child: GestureDetector(
        onTap: () => controller.scrollToBottom(),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: KColors.surfaceLight,
            shape: BoxShape.circle,
            border: Border.all(color: KColors.borderAlt, width: 1),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: const Icon(Icons.keyboard_arrow_down_rounded, color: KColors.muted, size: 20),
        ),
      ),
    );
  }

  // ── Reply Banner ──────────────────────────────
  Widget _buildReplyBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: KColors.surfaceLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
        border: Border(
          top: BorderSide(color: KColors.primary, width: 2),
          left: BorderSide(color: KColors.borderAlt),
          right: BorderSide(color: KColors.borderAlt),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.reply_rounded, color: KColors.primary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              controller.replyingToText.value ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: KColors.muted, fontSize: 13),
            ),
          ),
          GestureDetector(
            onTap: () => controller.setReplyingTo(null),
            child: const Icon(Icons.close_rounded, color: KColors.mutedDark, size: 16),
          ),
        ],
      ),
    );
  }

  // ── Input Bar ─────────────────────────────────
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      decoration: const BoxDecoration(
        color: KColors.surface,
        border: Border(top: BorderSide(color: KColors.borderLight, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _InputAction(icon: Icons.attach_file_rounded, onTap: () {}),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: KColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: KColors.borderAlt, width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.textCtrl,
                      focusNode: controller.focusNode,
                      maxLines: null,
                      style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                      decoration: const InputDecoration(
                        hintText: 'Message...',
                        hintStyle: TextStyle(color: KColors.mutedDark, fontSize: 15),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(16, 10, 8, 10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4, bottom: 6),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.emoji_emotions_outlined, color: KColors.mutedDark, size: 20),
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Obx(
            () => controller.inputText.value.trim().isEmpty
                ? _InputAction(icon: Icons.mic_rounded, onTap: () {})
                : _SendButton(onTap: () => controller.sendMessage(_currentUid), isSending: controller.isSending.value),
          ),
        ],
      ),
    );
  }

  // ── Message Options ───────────────────────────
  void _showMessageOptions(BuildContext context, Message msg) {
    HapticFeedback.mediumImpact();
    Get.bottomSheet(
      _MessageOptionsSheet(
        message: msg,
        isMe: msg.senderId == _currentUid,
        onReply: () {
          Get.back();
          controller.setReplyingTo(msg.text);
        },
        onCopy: () {
          Clipboard.setData(ClipboardData(text: msg.text));
          Get.back();
          Get.snackbar('Copied', 'Copied to clipboard', snackPosition: SnackPosition.BOTTOM, backgroundColor: KColors.surfaceLight, colorText: Colors.white);
        },
      ),
      backgroundColor: Colors.transparent,
    );
  }

  // ── Helpers ───────────────────────────────────
  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.isFirstInGroup,
    required this.senderInitial,
    required this.avatarColor,
    required this.onLongPress,
    required this.onSwipe,
  });

  final Message message;
  final bool isMe;
  final bool isFirstInGroup;
  final String senderInitial;
  final Color avatarColor;
  final VoidCallback onLongPress;
  final VoidCallback onSwipe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onHorizontalDragEnd: (d) {
        if (d.primaryVelocity != null && d.primaryVelocity! > 200) onSwipe();
      },
      child: Padding(
        padding: EdgeInsets.only(top: isFirstInGroup ? 8 : 2, bottom: 2),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe) ...[
              if (isFirstInGroup)
                CircleAvatar(
                  radius: 14,
                  backgroundColor: avatarColor,
                  child: Text(
                    senderInitial,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                )
              else
                const SizedBox(width: 28),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: isMe ? const LinearGradient(colors: [KColors.primary, KColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
                      color: isMe ? null : KColors.border,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isMe ? 18 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 18),
                      ),
                      boxShadow: [BoxShadow(color: isMe ? KColors.primary.withOpacity(0.2) : Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Text(message.text, style: TextStyle(color: isMe ? Colors.white : const Color(0xFFE0E0F0), fontSize: 15, height: 1.4)),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_formatTime(message.timestamp), style: const TextStyle(color: KColors.mutedDark, fontSize: 11)),
                      if (isMe) ...[const SizedBox(width: 3), const Icon(Icons.done_all_rounded, size: 13, color: KColors.primary)],
                    ],
                  ),
                ],
              ),
            ),
            if (isMe) ...[
              const SizedBox(width: 8),
              if (isFirstInGroup)
                CircleAvatar(
                  radius: 14,
                  backgroundColor: KColors.primary,
                  child: const Text(
                    'ME',
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                  ),
                )
              else
                const SizedBox(width: 28),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final p = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $p';
  }
}

class _InputAction extends StatelessWidget {
  const _InputAction({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: KColors.surfaceLight,
          shape: BoxShape.circle,
          border: Border.all(color: KColors.borderAlt),
        ),
        child: Icon(icon, color: KColors.muted, size: 20),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.onTap, required this.isSending});
  final VoidCallback onTap;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(colors: [KColors.primary, KColors.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [BoxShadow(color: KColors.primary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 3))],
        ),
        child: isSending
            ? const Center(
                child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
              )
            : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
      ),
    );
  }
}

class _MessageOptionsSheet extends StatelessWidget {
  const _MessageOptionsSheet({required this.message, required this.isMe, required this.onReply, required this.onCopy});
  final Message message;
  final bool isMe;
  final VoidCallback onReply;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: KColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: KColors.borderAlt),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['❤️', '😂', '😮', '😢', '👍', '👎'].map((e) {
                return GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(e, style: const TextStyle(fontSize: 28)),
                );
              }).toList(),
            ),
          ),
          const Divider(color: KColors.borderLight, height: 1),
          _OptionRow(icon: Icons.reply_rounded, label: 'Reply', onTap: onReply),
          _OptionRow(icon: Icons.copy_rounded, label: 'Copy', onTap: onCopy),
          _OptionRow(icon: Icons.forward_rounded, label: 'Forward', onTap: () => Get.back()),
          if (isMe) ...[const Divider(color: KColors.borderLight, height: 1), _OptionRow(icon: Icons.delete_rounded, label: 'Delete', color: const Color(0xFFEF4444), onTap: () => Get.back())],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.icon, required this.label, required this.onTap, this.color});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.white;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: c, size: 20),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(color: c, fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

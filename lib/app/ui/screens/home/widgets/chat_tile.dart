import 'package:flutter/material.dart';

import '../../../../data/models/chat_contact.dart';
import 'typing_indicator.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.contact});
  final ChatContact contact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        splashColor: const Color(0xFF6366F1).withOpacity(0.06),
        highlightColor: const Color(0xFF6366F1).withOpacity(0.03),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              // Avatar
              _buildAvatar(),
              const SizedBox(width: 14),
              // Content
              Expanded(child: _buildContent()),
              // Right side: time + badge
              _buildMeta(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 27,
          backgroundColor: contact.avatarColor.withOpacity(0.15),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: contact.avatarColor,
            child: Text(
              contact.avatarInitials,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
        ),
        if (contact.isOnline)
          Positioned(
            bottom: 1,
            right: 1,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0A0A0F), width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent() {
    final hasUnread = contact.unreadCount > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          contact.name,
          style: TextStyle(color: Colors.white, fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500, fontSize: 15.5, letterSpacing: -0.2),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        if (contact.isTyping)
          Row(
            children: [
              const TypingIndicator(),
              const SizedBox(width: 6),
              const Text(
                'typing...',
                style: TextStyle(color: Color(0xFF6366F1), fontSize: 13.5, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),
              ),
            ],
          )
        else
          Text(
            contact.lastMessage,
            style: TextStyle(color: hasUnread ? const Color(0xFFB0B0C8) : const Color(0xFF4B4B6A), fontSize: 13.5, fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _buildMeta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          contact.time,
          style: TextStyle(color: contact.unreadCount > 0 ? const Color(0xFF6366F1) : const Color(0xFF4B4B6A), fontSize: 12, fontWeight: contact.unreadCount > 0 ? FontWeight.w600 : FontWeight.w400),
        ),
        const SizedBox(height: 5),
        if (contact.unreadCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              contact.unreadCount > 99 ? '99+' : contact.unreadCount.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
            ),
          )
        else
          const SizedBox(height: 20),
      ],
    );
  }
}

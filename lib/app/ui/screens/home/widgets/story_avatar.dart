import 'package:flutter/material.dart';

import '../../../../data/models/chat_contact.dart';

class StoryAvatar extends StatelessWidget {
  const StoryAvatar({super.key, required this.contact});
  final ChatContact contact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Column(
        children: [
          Stack(
            children: [
              // Story ring
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: contact.isOnline ? const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
                  color: contact.isOnline ? null : const Color(0xFF1E1E30),
                ),
                padding: const EdgeInsets.all(2.5),
                child: Container(
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF0A0A0F)),
                  padding: const EdgeInsets.all(2),
                  child: CircleAvatar(
                    backgroundColor: contact.avatarColor,
                    child: Text(
                      contact.avatarInitials,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
                ),
              ),
              if (contact.isOnline)
                Positioned(
                  bottom: 2,
                  right: 2,
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
          ),
          const SizedBox(height: 5),
          Text(
            contact.name,
            style: const TextStyle(color: Color(0xFFB0B0C8), fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

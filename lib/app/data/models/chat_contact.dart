import 'package:flutter/material.dart';

class ChatContact {
  final String name;
  final String lastMessage;
  final String time;
  final String avatarInitials;
  final Color avatarColor;
  final int unreadCount;
  final bool isOnline;
  final bool isTyping;

  const ChatContact({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarInitials,
    required this.avatarColor,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isTyping = false,
  });
}

const chatsData = [
  ChatContact(name: 'Aria Johnson', lastMessage: 'typing...', time: 'now', avatarInitials: 'AJ', avatarColor: Color(0xFF6366F1), unreadCount: 3, isOnline: true, isTyping: true),
  ChatContact(name: 'Marcus Lee', lastMessage: 'Sounds good, see you tomorrow!', time: '2m', avatarInitials: 'ML', avatarColor: Color(0xFF10B981), unreadCount: 1, isOnline: true),
  ChatContact(name: 'Team Design', lastMessage: 'Priya: New assets are uploaded 🎨', time: '14m', avatarInitials: 'TD', avatarColor: Color(0xFFF59E0B), unreadCount: 12),
  ChatContact(name: 'Sofia Reyes', lastMessage: 'Did you see the announcement?', time: '1h', avatarInitials: 'SR', avatarColor: Color(0xFFEC4899), isOnline: true),
  ChatContact(name: 'Dev Crew', lastMessage: 'You: PR is ready for review', time: '3h', avatarInitials: 'DC', avatarColor: Color(0xFF3B82F6)),
  ChatContact(name: 'Lena Park', lastMessage: 'Thanks for the help 🙏', time: 'Tue', avatarInitials: 'LP', avatarColor: Color(0xFF8B5CF6)),
  ChatContact(name: 'Omar Faruk', lastMessage: "Let's catch up soon", time: 'Mon', avatarInitials: 'OF', avatarColor: Color(0xFF14B8A6)),
  ChatContact(name: 'Nina Wolff', lastMessage: 'Haha yes exactly 😂', time: 'Sun', avatarInitials: 'NW', avatarColor: Color(0xFFF97316)),
];

const storiesData = [
  ChatContact(name: 'Aria', lastMessage: '', time: '', avatarInitials: 'AJ', avatarColor: Color(0xFF6366F1), isOnline: true),
  ChatContact(name: 'Marcus', lastMessage: '', time: '', avatarInitials: 'ML', avatarColor: Color(0xFF10B981), isOnline: true),
  ChatContact(name: 'Sofia', lastMessage: '', time: '', avatarInitials: 'SR', avatarColor: Color(0xFFEC4899), isOnline: true),
  ChatContact(name: 'Lena', lastMessage: '', time: '', avatarInitials: 'LP', avatarColor: Color(0xFF8B5CF6)),
  ChatContact(name: 'Omar', lastMessage: '', time: '', avatarInitials: 'OF', avatarColor: Color(0xFF14B8A6)),
];

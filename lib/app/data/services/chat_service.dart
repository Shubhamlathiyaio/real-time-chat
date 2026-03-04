import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_contact.dart';
import '../models/message.dart';

@lazySingleton
class ChatService {
  final _client = Supabase.instance.client;

  // Deterministic 1-1 room ID
  String _getRoomId(String uid1, String uid2) {
    return uid1.compareTo(uid2) <= 0 ? '${uid1}_$uid2' : '${uid2}_$uid1';
  }

  // ─── Send Message ─────────────────────────────
  Future<void> sendMessage(String currentUid, String otherUid, String text) async {
    final roomId = _getRoomId(currentUid, otherUid);
    await _client.from('messages').insert({'chat_room_id': roomId, 'sender_id': currentUid, 'text': text});
  }

  // ─── Realtime Messages Stream ─────────────────
  Stream<List<Message>> getMessages(String currentUid, String otherUid) {
    final roomId = _getRoomId(currentUid, otherUid);

    // Supabase realtime channel
    return _client.from('messages').stream(primaryKey: ['id']).eq('chat_room_id', roomId).order('created_at', ascending: false).map((rows) => rows.map((e) => Message.fromMap(e)).toList());
  }

  // ─── Realtime Chat List Stream ────────────────
  Stream<List<ChatContact>> get chatsStream {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return Stream.value([]);

    return _client.from('messages').stream(primaryKey: ['id']).order('created_at', ascending: false).map((rows) {
      final Map<String, Map<String, dynamic>> latestByRoom = {};

      for (final row in rows) {
        final roomId = row['chat_room_id'] as String;
        // Only process rooms this user belongs to
        if (roomId.contains(uid)) {
          // Since it's ordered by created_at DESC, the first message per room is the latest
          if (!latestByRoom.containsKey(roomId)) {
            latestByRoom[roomId] = row;
          }
        }
      }

      return latestByRoom.values.map((row) {
        final roomId = row['chat_room_id'] as String;
        final parts = roomId.split('_');
        // Handle cases where the UID might be a prefix/suffix safely
        final otherUid = parts[0] == uid ? parts[1] : parts[0];

        return ChatContact(
          id: otherUid,
          name: 'User ${otherUid.substring(0, 4)}',
          lastMessage: row['text'] as String,
          time: _formatTimestamp(row['created_at'] as String),
          avatarInitials: 'U',
          avatarColor: const Color(0xFF6366F1),
        );
      }).toList();
    });
  }

  String _formatTimestamp(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
        return '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
      }
      return '${dt.day}/${dt.month}';
    } catch (_) {
      return 'now';
    }
  }

  // ─── Fetch All Chat Rooms for Home Screen ──────
  Future<List<Map<String, dynamic>>> getRecentChats(String uid) async {
    // Get distinct messages involving this user
    // Note: or() works on standard select(), but not on stream()
    final data = await _client.from('messages').select('chat_room_id, text, created_at, sender_id').or('chat_room_id.like.%$uid%,chat_room_id.like.%$uid%').order('created_at', ascending: false);

    // Group by room, keep only latest
    final Map<String, Map<String, dynamic>> latest = {};
    for (final row in data) {
      final roomId = row['chat_room_id'] as String;
      if (!latest.containsKey(roomId)) {
        latest[roomId] = row;
      }
    }
    return latest.values.toList();
  }

  // ─── Delete a Message ─────────────────────────
  Future<void> deleteMessage(String messageId) async {
    await _client.from('messages').delete().eq('id', messageId);
  }

  // ─── Get All Users (for new chat) ─────────────
  Future<List<Map<String, dynamic>>> getAllUsers(String currentUid) async {
    final data = await _client.from('profiles').select('id, email, display_name, avatar_url').neq('id', currentUid);
    return List<Map<String, dynamic>>.from(data);
  }
}

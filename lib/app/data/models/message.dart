class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  const Message({required this.id, required this.senderId, required this.text, required this.timestamp});

  // ✅ From Supabase row (Map)
  factory Message.fromMap(Map<String, dynamic> data) {
    return Message(id: data['id'] as String, senderId: data['sender_id'] as String, text: data['text'] as String, timestamp: DateTime.parse(data['created_at'] as String).toLocal());
  }

  // ✅ To Supabase insert map
  Map<String, dynamic> toInsertMap({required String chatRoomId}) {
    return {
      'chat_room_id': chatRoomId,
      'sender_id': senderId,
      'text': text,
      // created_at is set by Supabase server default
    };
  }
}

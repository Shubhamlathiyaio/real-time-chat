import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:real_time_chat/app/data/models/chat_contact.dart';
import 'package:real_time_chat/app/data/models/message.dart';

@lazySingleton
class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ChatContact>> get chatsStream => Stream.value(chatsData);

  Stream<List<Message>> getMessages(String currentUid, String otherUid) {
    final ids = [currentUid, otherUid]..sort();
    final chatRoomId = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> sendMessage(String senderId, String receiverId, String text) async {
    final ids = [senderId, receiverId]..sort();
    final chatRoomId = ids.join('_');

    final message = Message(id: '', senderId: senderId, receiverId: receiverId, text: text, timestamp: DateTime.now());

    await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(message.toMap());

    // Update last message in chat_rooms (metadata) - optional but good for chat list
    await _firestore.collection('chat_rooms').doc(chatRoomId).set({'lastMessage': text, 'timestamp': FieldValue.serverTimestamp(), 'users': ids}, SetOptions(merge: true));
  }
}

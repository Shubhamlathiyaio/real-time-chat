import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_time_chat/app/data/models/message.dart';
import 'package:real_time_chat/app/data/services/chat_service.dart';
import 'package:real_time_chat/app/utils/helpers/injectable/injectable.dart';

class ChatDetailsController extends GetxController {
  final String otherUid;
  final _chatService = getIt<ChatService>();
  final textCtrl = TextEditingController();
  final scrollCtrl = ScrollController();
  final focusNode = FocusNode();

  final messages = <Message>[].obs;
  final isSending = false.obs;
  final showScrollDown = false.obs;
  final replyingToText = RxnString();
  final inputText = ''.obs;

  ChatDetailsController({required this.otherUid});

  @override
  void onInit() {
    super.onInit();
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? 'current_user_id';
    messages.bindStream(_chatService.getMessages(currentUid, otherUid));

    textCtrl.addListener(() {
      inputText.value = textCtrl.text;
    });

    scrollCtrl.addListener(() {
      final show = scrollCtrl.offset > 300;
      if (show != showScrollDown.value) showScrollDown.value = show;
    });
  }

  @override
  void onClose() {
    textCtrl.dispose();
    scrollCtrl.dispose();
    focusNode.dispose();
    super.onClose();
  }

  Future<void> sendMessage(String currentUid) async {
    final text = textCtrl.text.trim();
    if (text.isEmpty || isSending.value) return;

    isSending.value = true;
    textCtrl.clear();
    replyingToText.value = null;

    try {
      await _chatService.sendMessage(currentUid, otherUid, text);
      if (scrollCtrl.hasClients) {
        scrollCtrl.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } finally {
      isSending.value = false;
    }
  }

  void setReplyingTo(String? text) {
    replyingToText.value = text;
    if (text != null) focusNode.requestFocus();
  }

  void scrollToBottom() {
    if (scrollCtrl.hasClients) {
      scrollCtrl.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
}

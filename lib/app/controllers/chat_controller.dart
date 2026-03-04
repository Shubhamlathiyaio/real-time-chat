import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:real_time_chat/app/data/models/chat_contact.dart';

@lazySingleton
class ChatController extends GetxController {

RxString searchQuery = ''.obs;

  RxList<ChatContact> get filteredChats =>
      chatsData.where((c) => c.name.toLowerCase().contains(searchQuery.toLowerCase()) || c.lastMessage.toLowerCase().contains(searchQuery.toLowerCase())).toList().obs;


}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:real_time_chat/app/data/services/chat_service.dart';
import 'package:real_time_chat/app/utils/helpers/injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class UsersController extends GetxController {
  final _chatService = getIt<ChatService>();
  final users = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final currentUid = Supabase.instance.client.auth.currentUser?.id ?? '';
    try {
      isLoading.value = true;
      final fetchedUsers = await _chatService.getAllUsers(currentUid);
      users.assignAll(fetchedUsers);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch users: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}

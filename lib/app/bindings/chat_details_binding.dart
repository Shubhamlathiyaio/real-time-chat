import 'package:get/get.dart';
import 'package:real_time_chat/app/controllers/chat_details_controller.dart';

class ChatDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final otherUid = Get.arguments['otherUid'] as String;
    Get.lazyPut(() => ChatDetailsController(otherUid: otherUid));
  }
}

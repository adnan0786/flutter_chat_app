import 'package:flutter_chat_app/controllers/callHistoryController.dart';
import 'package:flutter_chat_app/controllers/chatController.dart';
import 'package:flutter_chat_app/controllers/contactController.dart';
import 'package:flutter_chat_app/controllers/profileController.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => CallHistoryController());
    // Get.lazyPut(() => ContactController());
    Get.lazyPut(() => ProfileController());
  }
}

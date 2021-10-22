import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:get/get.dart';

class MediaController extends GetxController {
  FirebaseService service = FirebaseService();

  RxList<MessageModel> mediaMessages = RxList();

  List<MessageModel> get messages => mediaMessages;

  void readMediaMessages(String chatId) {
    mediaMessages.bindStream(service.getMediaMessages(chatId));
  }
}

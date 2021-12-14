import 'package:flutter_chat_app/controllers/messageController.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:get/get.dart';

class MediaController extends GetxController {
  FirebaseService service = FirebaseService();

  RxList<MessageModel> mediaVideoMessages = RxList();

  RxList<MessageModel> mediaAudioMessages = RxList();

  RxList<MessageModel> mediaImageMessages = RxList();

  RxList<MessageModel> mediaFileMessages = RxList();
  late String chatId;

  void readMediaVideoMessages(String chatId) {
    mediaVideoMessages.bindStream(service.getMediaVideoMessages(chatId));
  }

  void readMediaImagesMessages(String chatId) {
    mediaImageMessages.bindStream(service.getMediaImageMessages(chatId));
  }

  void readMediaAudioMessages(String chatId) {
    mediaAudioMessages.bindStream(service.getMediaAudioMessages(chatId));
  }

  void readMediaFileMessages(String chatId) {
    mediaFileMessages.bindStream(service.getMediaFileMessages(chatId));
  }

  @override
  void onClose() {
    Get.find<MessageController>().stopPlayer();
    super.onClose();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:get/get.dart';

class StarredMessageController extends GetxController {
  FirebaseService service = FirebaseService();
  String? chatId;
  String? userName;
  String? userImage;
  RxList<MessageModel> starredMessages = RxList();
  String myId = FirebaseAuth.instance.currentUser!.uid;
  String myName = FirebaseAuth.instance.currentUser!.displayName!;
  String myImage = FirebaseAuth.instance.currentUser!.photoURL!;

  List<MessageModel> get messages => starredMessages;

  void readChatMessages() {
    if (chatId != null)
      starredMessages.bindStream(service.getStarredMessages(chatId!));
  }
}

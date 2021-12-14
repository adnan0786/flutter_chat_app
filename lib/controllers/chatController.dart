import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_app/models/chatModel.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var isLoading = true.obs;
  late Stream<List<ChatModel>> chat;
  FirebaseService service = FirebaseService();
  RxList<ChatModel> userChats = RxList();

  List<ChatModel> get chats => userChats;
  User user = FirebaseAuth.instance.currentUser!;

  @override
  void onInit() {
    super.onInit();
    userChats.bindStream(service.getChatList());
  }
}

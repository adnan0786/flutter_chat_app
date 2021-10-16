import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/starredMessageController.dart';
import 'package:flutter_chat_app/widgets/starredMessageView.dart';
import 'package:get/get.dart';

class StarMessagesScreen extends GetView<StarredMessageController> {
  const StarMessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(StarredMessageController());
    controller.chatId = Get.arguments[0];
    controller.userName = Get.arguments[1];
    controller.userImage = Get.arguments[2];

    return Scaffold(
      appBar: AppBar(
        title: Text("Starred Messages"),
      ),
      body: ListView.builder(
          padding: EdgeInsets.only(top: 20),
          itemCount: controller.messages.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return StarredMessageView(
                chatMessageModel: controller.messages[index],
                myId: controller.myId);
          }),
    );
  }
}

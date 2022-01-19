import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/starredMessageController.dart';
import 'package:flutter_chat_app/widgets/starFileView.dart';
import 'package:flutter_chat_app/widgets/starImageView.dart';
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
    controller.readChatMessages();

    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: Text("Starred_Messages".tr,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1?.color,
                    fontWeight: FontWeight.bold)),
          ),
          body: ListView.builder(
              padding: EdgeInsets.only(top: 20),
              itemCount: controller.messages.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return controller.messages[index].type == "text"
                    ? StarredMessageView(
                        chatMessageModel: controller.messages[index],
                        myId: controller.myId,
                        userImage: controller.userImage!,
                        myImage: controller.myImage,
                      )
                    : controller.messages[index].type == "image"
                        ? StarImageView(
                            chatMessageModel: controller.messages[index],
                            myId: controller.myId,
                            userImage: controller.userImage!,
                            myImage: controller.myImage,
                          )
                        : StarFileView(
                            chatMessageModel: controller.messages[index],
                            myId: controller.myId,
                            userImage: controller.userImage!,
                            myImage: controller.myImage,
                          );
              }),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/chatController.dart';
import 'package:flutter_chat_app/screens/messageScreen.dart';
import 'package:flutter_chat_app/utils/cusotmSearchDelegate.dart';
import 'package:flutter_chat_app/widgets/chatListView.dart';
import 'package:flutter_chat_app/widgets/loadingLayout.dart';
import 'package:get/get.dart';

class ChatListScreen extends GetView<ChatController> {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate(controller.chats));
                },
                icon: Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                ))
          ],
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            "Messages",
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1?.color,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Obx(() {
          return controller.chats.length == 0
              ? LoadingLayout()
              : ListView.builder(
                  itemCount: controller.chats.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 16),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatListView(
                      callback: (chatModel, userId) {
                        Get.to(MessageScreen(), arguments: [chatModel, userId]);
                      },
                      chatModel: controller.chats[index],
                      chatController: controller,
                    );
                  },
                );
        }));
  }
}

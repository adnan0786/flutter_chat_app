import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/chatController.dart';
import 'package:flutter_chat_app/models/status.dart';
import 'package:flutter_chat_app/screens/messageScreen.dart';
import 'package:flutter_chat_app/screens/statusScreen.dart';
import 'package:flutter_chat_app/utils/cusotmSearchDelegate.dart';
import 'package:flutter_chat_app/widgets/chatListView.dart';
import 'package:flutter_chat_app/widgets/loadingLayout.dart';
import 'package:flutter_chat_app/widgets/statusLoadingView.dart';
import 'package:get/get.dart';
import 'package:status_view/status_view.dart';

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
                      context: context,
                      delegate: CustomSearchDelegate(controller.chats));
                },
                icon: Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                ))
          ],
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            "Messages".tr,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1?.color,
                fontWeight: FontWeight.bold),
          ),

        ),
        body: Obx(() {
          return controller.chats.length == 0
              ? Column(
                  children: [
                    Container(
                      height: 80,
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 0),
                      child: StatusLoadingView(),
                    ),
                    Expanded(child: LoadingLayout())
                  ],
                )
              : Column(
                  children: [
                    Container(
                      height: 80,
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 0),
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: controller.status.isEmpty
                                ? Stack(
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          onTap: () {
                                            controller.showPicker(context);
                                          },
                                          child: Container(
                                            width: 65,
                                            height: 65,
                                            decoration:
                                                BoxDecoration(boxShadow: [
                                              BoxShadow(
                                                  color: Theme.of(context)
                                                      .shadowColor
                                                      .withOpacity(0.2),
                                                  offset: Offset(1, 1),
                                                  blurRadius: 15,
                                                  spreadRadius: 1)
                                            ]),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                controller.user.photoURL!,
                                              ),
                                              maxRadius: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 5,
                                        bottom: 0,
                                        child: Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.add_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Stack(
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          onTap: () {
                                            Get.to(StatusScreen(), arguments: [
                                              false,
                                              controller.myStatus.value,
                                              controller.user.photoURL,
                                              controller.user.displayName,
                                              controller.user.uid
                                            ]);
                                          },
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            child: StatusView(
                                              radius: 30,
                                              spacing: 15,
                                              strokeWidth: 2,
                                              indexOfSeenStatus:
                                                  controller.status.length,
                                              numberOfStatus:
                                                  controller.status.length,
                                              padding: 3,
                                              seenColor: Colors.grey,
                                              unSeenColor: Colors.red,
                                              centerImageUrl: controller
                                                          .status[0].type ==
                                                      "image"
                                                  ? controller.status[0].image
                                                  : controller.user.photoURL!,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 5,
                                        bottom: 0,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            onTap: () {
                                              controller.showPicker(context);
                                            },
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.add_rounded,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          controller.allStories.length == 0
                              ? Expanded(child: StatusLoadingView())
                              : Expanded(
                                  child: ListView.builder(
                                    itemCount: controller.allStories.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return FutureBuilder<List<Status>>(
                                          future: controller.getStories(
                                              controller
                                                  .allStories[index].userId),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Padding(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {},
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                        onTap: () {
                                                          Get.to(StatusScreen(),
                                                              arguments: [
                                                                true,
                                                                snapshot.data,
                                                                controller
                                                                    .allStories[
                                                                        index]
                                                                    .image,
                                                                controller
                                                                    .allStories[
                                                                        index]
                                                                    .name,
                                                                controller
                                                                    .allStories[
                                                                        index]
                                                                    .userId
                                                              ]);
                                                        },
                                                        child: StatusView(
                                                          radius: 30,
                                                          spacing: 15,
                                                          strokeWidth: 2,
                                                          indexOfSeenStatus:
                                                              snapshot.data!
                                                                      .length -
                                                                  1,
                                                          numberOfStatus:
                                                              snapshot
                                                                  .data!.length,
                                                          padding: 3,
                                                          seenColor:
                                                              Colors.grey,
                                                          unSeenColor:
                                                              Colors.red,
                                                          centerImageUrl:
                                                              controller
                                                                  .allStories[
                                                                      index]
                                                                  .image,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Text("waiting");
                                            }
                                          });
                                    },
                                  ),
                                )
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.chats.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 16),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatListView(
                            callback: (chatModel, userId) {
                              Get.to(MessageScreen(),
                                  arguments: [chatModel, userId]);
                            },
                            chatModel: controller.chats[index],
                            chatController: controller,
                          );
                        },
                      ),
                    )
                  ],
                );
        }));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_app/common/appConstants.dart';
import 'package:flutter_chat_app/controllers/messageController.dart';
import 'package:flutter_chat_app/models/chatMessageModel.dart';
import 'package:flutter_chat_app/models/chatModel.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:flutter_chat_app/models/userModel.dart';
import 'package:flutter_chat_app/screens/photoPreviewScreen.dart';
import 'package:flutter_chat_app/screens/userInfoScreen.dart';
import 'package:flutter_chat_app/screens/videoCallScreen.dart';
import 'package:flutter_chat_app/screens/videoPlayerScreen.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';
import 'package:flutter_chat_app/widgets/audioMessageView.dart';
import 'package:flutter_chat_app/widgets/fileMessageView.dart';
import 'package:flutter_chat_app/widgets/imageMessageView.dart';
import 'package:flutter_chat_app/widgets/loadingLayout.dart';
import 'package:flutter_chat_app/widgets/locationMessageView.dart';
import 'package:flutter_chat_app/widgets/misscallMessageView.dart';
import 'package:flutter_chat_app/widgets/textMessageView.dart';
import 'package:flutter_chat_app/widgets/videoMessageView.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../appTheme.dart';

class MessageScreen extends GetView<MessageController> {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MessageController());
    if (Get.arguments != null) {
      if (Get.arguments[0] is UserModel) {
        UserModel userModel = Get.arguments[0];
        controller.userModel.value = userModel;
        controller.checkChatExist();
      } else {
        ChatModel chatModel = Get.arguments[0];
        String userId = Get.arguments[1];
        controller.userModel.value = UserModel(
            uId: userId,
            name: chatModel.name!,
            image: chatModel.image!,
            number: "",
            status: "",
            typing: "",
            online: "");
        controller.chatId = chatModel.chatId;
        controller.readChatMessages(controller.chatId!);
      }
      controller.checkUserUpdates();
    }

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).backgroundColor,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  controller.user.image == ""
                      ? Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Get.to(
                                  PhotoPreviewScreen(
                                      userImage: controller.user.image),
                                  transition: Transition.zoom);
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/default.png"),
                              maxRadius: 20,
                            ),
                          ),
                        )
                      : Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Get.to(
                                  PhotoPreviewScreen(
                                      userImage: controller.user.image),
                                  transition: Transition.zoom);
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(controller.user.image),
                              maxRadius: 20,
                            ),
                          ),
                        ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            controller.user.name == ""
                                ? "No Name"
                                : controller.user.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          controller.typing.value,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (controller.chatId != null) {
                        // Get.to(VideoCallScreen(), arguments: [
                        //   controller.chatId,
                        //   controller.user.uId,
                        //   "audio"
                        // ]);
                      }
                    },
                    icon: Icon(
                      Icons.call,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.to(VideoCallScreen(), arguments: [
                        controller.chatId,
                        controller.user.uId,
                        "video"
                      ]);
                    },
                    icon: Icon(
                      Icons.videocam_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.to(
                          UserInfoScreen(
                            userModel: controller.user,
                          ),
                          arguments: [controller.chatId]);
                    },
                    icon: Icon(
                      Icons.info,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: <Widget>[
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 60,
                  top: 0,
                  child: controller.messages.length == 0
                      ? LoadingLayout()
                      : ListView.builder(
                          itemCount: controller.messages.length,
                          shrinkWrap: true,
                          controller: controller.scrollController,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(left: 40),
                              child: FocusedMenuHolder(
                                  menuWidth:
                                      MediaQuery.of(context).size.width * 0.50,
                                  blurSize: 5.0,
                                  menuBoxDecoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  duration: Duration(milliseconds: 100),
                                  animateMenuItems: true,
                                  blurBackgroundColor: Colors.black54,
                                  bottomOffsetHeight: 80.0,
                                  menuItems: <FocusedMenuItem>[
                                    if (controller.messages[index].type ==
                                            "text" ||
                                        controller.messages[index].type ==
                                            "image" ||
                                        AppConstants.supportedFiles.contains(
                                            controller.messages[index].type))
                                      FocusedMenuItem(
                                          title: Text(
                                              controller.messages[index].star
                                                  ? "Unstar"
                                                  : "Star"),
                                          trailingIcon: controller
                                                  .messages[index].star
                                              ? Icon(
                                                  Icons.star_rounded,
                                                  color: Color(0xffffdf00),
                                                )
                                              : Icon(Icons.star_border_rounded),
                                          onPressed: () {
                                            controller.addStartMessage(
                                                controller.messages[index].id,
                                                !controller
                                                    .messages[index].star);
                                          }),
                                    FocusedMenuItem(
                                        title: Text("Reply".tr),
                                        trailingIcon: Icon(Icons.reply_rounded),
                                        onPressed: () {}),
                                    if (controller.messages[index].type ==
                                        "text")
                                      FocusedMenuItem(
                                          title: Text("Copy".tr),
                                          trailingIcon:
                                              Icon(Icons.copy_rounded),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: controller
                                                    .messages[index].message));
                                            showErrorSnackBar(
                                                context,
                                                "Copied to clipboard",
                                                "Copy",
                                                false);
                                          }),
                                    FocusedMenuItem(
                                        title: Text(
                                          "Delete".tr,
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        ),
                                        trailingIcon: Icon(
                                          Icons.delete_rounded,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () {
                                          controller.deleteMessage(
                                              controller.messages[index]);
                                        }),
                                  ],
                                  onPressed: () {},
                                  child: controller.messages[index].type ==
                                          "text"
                                      ? TextMessageView(
                                          onSwipedMessage: (model) {},
                                          chatMessageModel:
                                              controller.messages[index],
                                          myId: controller.myId,
                                        )
                                      : controller.messages[index].type ==
                                              "image"
                                          ? ImageMessageView(
                                              chatMessageModel:
                                                  controller.messages[index],
                                              myId: controller.myId,
                                              onImageClick: () {
                                                Get.to(
                                                    PhotoPreviewScreen(
                                                        userImage: controller
                                                            .messages[index]
                                                            .message),
                                                    transition:
                                                        Transition.zoom);
                                              },
                                            )
                                          : controller.messages[index].type ==
                                                  "video"
                                              ? VideoMessageView(
                                                  chatMessageModel: controller
                                                      .messages[index],
                                                  myId: controller.myId,
                                                  onImageClick: () {
                                                    Get.to(
                                                        VideoPlayerScreen(
                                                          chatMessageModel:
                                                              controller
                                                                      .messages[
                                                                  index],
                                                        ),
                                                        transition: Transition
                                                            .rightToLeft);
                                                  },
                                                )
                                              : controller.messages[index]
                                                          .type ==
                                                      "call"
                                                  ? MissCallMessageView(
                                                      messageModel: controller
                                                          .messages[index],
                                                      myId: controller.myId)
                                                  : controller.messages[index]
                                                              .type ==
                                                          "location"
                                                      ? LocationMessageView(
                                                          chatMessageModel: controller
                                                              .messages[index],
                                                          myId: controller.myId,
                                                          onLocationClick:
                                                              (locationModel) async {
                                                            String googleUrl =
                                                                'https://www.google.com/maps/search/?api=1&query=${locationModel.lat},${locationModel.lng}';
                                                            if (await canLaunch(
                                                                googleUrl)) {
                                                              await launch(
                                                                  googleUrl);
                                                            }
                                                          })
                                                      : AppConstants
                                                              .supportedFiles
                                                              .contains(controller
                                                                  .messages[index]
                                                                  .type)
                                                          ? FileMessageView(
                                                              myId: controller
                                                                  .myId,
                                                              chatMessageModel:
                                                                  controller
                                                                          .messages[
                                                                      index],
                                                              onSwipedMessage:
                                                                  (messageModel) {},
                                                              onFileClick:
                                                                  (file) async {
                                                                if (await canLaunch(
                                                                    file)) {
                                                                  await launch(
                                                                      file);
                                                                }
                                                              },
                                                            )
                                                          : AudioMessageView(
                                                              messageModel:
                                                                  controller
                                                                          .messages[
                                                                      index],
                                                              myId: controller
                                                                  .myId,
                                                            )),
                            );
                          },
                        )),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding / 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 32,
                        color: Theme.of(context).primaryColor.withOpacity(0.08),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: Visibility(
                            visible: controller.isRecording.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      onTap: () {
                                        controller.showPicker(context);
                                      },
                                      child: Center(
                                        child: Icon(Icons.add,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller:
                                                controller.massageController,
                                            focusNode: controller.focusNode,
                                            onChanged: (text) {
                                              if (text.isEmpty) {
                                                controller.isTyping(true);
                                              } else {
                                                controller.isTyping(false);
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: "Type message",
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        FocusedMenuHolder(
                                          menuWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.50,
                                          blurSize: 5.0,
                                          openWithTap: false,
                                          menuBoxDecoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0))),
                                          duration: Duration(milliseconds: 100),
                                          animateMenuItems: true,
                                          blurBackgroundColor: Colors.black54,
                                          bottomOffsetHeight: 80.0,
                                          menuItems: <FocusedMenuItem>[
                                            FocusedMenuItem(
                                                title: Text("Record New Video"),
                                                trailingIcon: Icon(
                                                    Icons.videocam_rounded),
                                                onPressed: () {
                                                  controller
                                                      .recordVideo(context);
                                                }),
                                            FocusedMenuItem(
                                                title: Text("Gallery"),
                                                trailingIcon: Icon(Icons
                                                    .video_collection_rounded),
                                                onPressed: () {
                                                  controller.pickVideo(context);
                                                }),
                                          ],
                                          onPressed: () {},
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                onTap: () async {
                                                  await SystemChannels.textInput
                                                      .invokeMapMethod(
                                                          "TextInput.hide");
                                                },
                                                child: Center(
                                                    child: Icon(
                                                  Icons.camera_alt_rounded,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            replacement: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.delete,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(controller.time.toString()),
                                      Expanded(
                                          child: Shimmer.fromColors(
                                        highlightColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        baseColor: Colors.black38,
                                        direction: ShimmerDirection.ltr,
                                        period: Duration(seconds: 2),
                                        child: Center(
                                          child: Text(
                                            "Swipe to delete",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Visibility(
                          visible: controller.isTyping.value,
                          replacement: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  if (controller
                                      .massageController.text.isNotEmpty) {
                                    if (controller.chatId!.isNotEmpty) {
                                      controller.sendTextMessage(MessageModel(
                                          "",
                                          controller.myId,
                                          controller.user.uId,
                                          controller.massageController.text
                                              .trim(),
                                          Timestamp.now(),
                                          "text",
                                          false,
                                          false,
                                          ""));
                                    } else {
                                      controller.createChat(MessageModel(
                                          "",
                                          controller.myId,
                                          controller.user.uId,
                                          controller.massageController.text
                                              .trim(),
                                          Timestamp.now(),
                                          "text",
                                          false,
                                          false,
                                          ""));
                                    }
                                  }
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          child: AnimatedBuilder(
                            builder: (context, child) {
                              return GestureDetector(
                                onLongPress: () {
                                  controller.controller..forward();
                                  controller.isRecording.value = false;
                                  controller.startRecording();
                                },
                                onLongPressEnd: (details) {
                                  controller.controller.reverse();
                                  controller.isRecording.value = true;
                                  controller.stopRecording();
                                },
                                onLongPressMoveUpdate: (detail) {
                                  if (detail.localPosition.dx < -5) {
                                    controller.controller.reverse();
                                    controller.isRecording.value = true;
                                    controller.stopRecording();
                                  }
                                },
                                child: Container(
                                  width: controller.controller.value,
                                  height: controller.controller.value,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Icon(
                                      Icons.mic_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                            animation: controller.controller,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  void replyToMessage(ChatMessageModel message) {
    controller.replyMessage = message;
  }

// void cancelReply() {
//   controller.replyMessage;
// }
}

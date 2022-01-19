import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/mediaController.dart';
import 'package:flutter_chat_app/controllers/messageController.dart';
import 'package:flutter_chat_app/widgets/mediaAudioView.dart';
import 'package:flutter_chat_app/widgets/mediaFileView.dart';
import 'package:flutter_chat_app/widgets/mediaImageView.dart';
import 'package:flutter_chat_app/widgets/mediaVideoView.dart';
import 'package:get/get.dart';

class MediaMessagesScreen extends GetView<MediaController> {
  const MediaMessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MediaController());
    controller.chatId = Get.arguments[0];
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(
                      color: Theme.of(context).textTheme.bodyText1?.color),
                  backgroundColor: Theme.of(context).backgroundColor,
                  title: Text(
                    'Media'.tr,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        fontWeight: FontWeight.bold),
                  ),
                  pinned: true,
                  floating: true,
                  bottom: TabBar(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    indicator: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(25)),
                    unselectedLabelColor: Theme.of(context).disabledColor,
                    tabs: [
                      Tab(child: Text('Photos'.tr)),
                      Tab(child: Text('Videos'.tr)),
                      Tab(child: Text('Audios'.tr)),
                      Tab(child: Text('Files'.tr)),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                MediaImageView(controller: controller),
                MediaVideoView(controller: controller),
                MediaAudioView(
                  controller: controller,
                  callback: (messageModel) {
                    Get.find<MessageController>()
                        .startPlayer(messageModel.message);
                  },
                ),
                MediaFileView(controller: controller)
              ],
            )),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/mediaController.dart';
import 'package:flutter_chat_app/widgets/mediaImageView.dart';
import 'package:flutter_chat_app/widgets/mediaVideoView.dart';
import 'package:get/get.dart';

class MediaMessagesScreen extends GetView<MediaController> {
  const MediaMessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MediaController());
    controller.readMediaMessages(Get.arguments[0]);
    return DefaultTabController(
      length: 3,
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
                    'Media',
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
                      Tab(child: Text('Photos')),
                      Tab(child: Text('Videos')),
                      Tab(child: Text('Audios')),
                    ],
                  ),
                ),
              ];
            },
            body: Obx(()=>TabBarView(
              children: <Widget>[
                MediaImageView(imageMessages: controller.mediaMessages),
                MediaVideoView(imageMessages: controller.mediaMessages),
                Icon(Icons.directions_car, size: 350),
              ],
            ))),
      ),
    );
  }
}

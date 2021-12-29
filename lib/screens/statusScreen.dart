import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/statusController.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';
import 'package:get/get.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

class StatusScreen extends GetView<StatusController> {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(StatusController());
    controller.allStatus = Get.arguments[0];
    controller.arrangeStoryList();
    controller.image = Get.arguments[1];
    controller.name = Get.arguments[2];
    return Obx(() => controller.isStory.value
        ? storyView()
        : Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text(
                "Status",
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1?.color,
                    fontWeight: FontWeight.bold),
              ),
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            ),
            body: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: controller.status.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 3.0,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            controller.isStory.value = true;
                          },
                          child: Container(
                            height: 70,
                            padding: EdgeInsets.only(
                                left: 30, right: 10, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                controller.status[index].type == "image"
                                    ? Container(
                                        height: 50,
                                        width: 50,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            controller.status[index].image,
                                          ),
                                          maxRadius: 20,
                                        ),
                                      )
                                    : Container(
                                        height: 50,
                                        width: 50,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.primaries[Random()
                                                .nextInt(
                                                    Colors.primaries.length)]),
                                        child: Center(
                                          child: Text(
                                            controller.status[index].image,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  width: 40,
                                ),
                                Text(
                                  timeAgo(
                                      controller.status[index].date.toDate()),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ))
              ],
            ),
          ));
  }

  Widget storyView() {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: StoryView(
            controller: controller.storyController,
            onStoryShow: (s) {
              var index = controller.story.indexOf(s);
              // controller.date.value = controller.status[index].date;
            },
            onComplete: () {
              controller.isStory.value = false;
            },
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                controller.isStory.value = false;
              }
            },
            storyItems: controller.story,
          ),
        ),
        Positioned(
            top: 80,
            left: 20,
            child: Container(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      controller.image,
                    ),
                    maxRadius: 20,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.name,
                        style: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Text(timeAgo(controller.date.value.toDate()),
                      //     style: TextStyle(
                      //       fontSize: 10,
                      //       decoration: TextDecoration.none,
                      //       color: Colors.white,
                      //     )),
                    ],
                  )
                ],
              ),
            ))
      ],
    );
  }
}

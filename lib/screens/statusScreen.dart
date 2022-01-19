import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/statusController.dart';
import 'package:flutter_chat_app/models/status.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';
import 'package:get/get.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

class StatusScreen extends GetView<StatusController> {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(StatusController());

    controller.isStory.value = Get.arguments[0];
    controller.allStatus.value = Get.arguments[1];
    controller.arrangeStoryList();
    controller.image = Get.arguments[2];
    controller.name = Get.arguments[3];
    controller.userId = Get.arguments[4];

    return Obx(() => controller.isStory.value
        ? storyView()
        : Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text(
                "Status".tr,
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
                    return Dismissible(
                      key: Key(
                        index.toString(),
                      ),
                      onDismissed: (direction) {
                        controller.deleteStatus(controller.status[index].id);
                      },
                      background: Container(
                        color: Colors.red,
                        padding: const EdgeInsets.only(right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Icon(
                              Icons.delete_rounded,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      child: Padding(
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.primaries[Random()
                                                  .nextInt(Colors
                                                      .primaries.length)]),
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        controller.status[index].members
                                                    .length <
                                                0
                                            ? "0 Views"
                                            : "${controller.status[index].members.length} Views",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        timeAgo(controller.status[index].date
                                            .toDate()),
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  )
                                ],
                              ),
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
              if (controller.myId != controller.userId) {
                var index = controller.story.indexOf(s);
                Status status = controller.status[index];

                if (status.members.length > 0) {
                  if (!status.members.contains(controller.myId)) {
                    controller.seenStatus(status.id, status.members);
                  }
                } else {
                  controller.seenStatus(status.id, []);
                }
              }

              if (controller.userId == controller.myId) {}
            },
            onComplete: () {
              if (Get.arguments[0]) {
                Get.back();
              } else {
                controller.isStory.value = false;
              }
            },
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                if (Get.arguments[0]) {
                  Get.back();
                } else {
                  controller.isStory.value = false;
                }
              } else if (direction == Direction.up) {}
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

  void memberBottomSheet() {
    Get.bottomSheet(Container(
      padding: EdgeInsets.only(top: 10),
    ));
  }
}

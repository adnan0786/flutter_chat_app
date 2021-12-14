import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/mediaController.dart';
import 'package:get/get.dart';

class MediaFileView extends StatelessWidget {
  final MediaController controller;

  const MediaFileView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.readMediaFileMessages(controller.chatId);
    return Obx(() => Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: GridView.builder(
              itemCount: controller.mediaFileMessages.length,
              physics: BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 15),
              itemBuilder: (context, index) {
                return Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                        color: controller.mediaFileMessages[index].type ==
                                "pdf"
                            ? Colors.red
                            : controller.mediaFileMessages[index].type ==
                                    "docx"
                                ? Colors.blue.shade600
                                : Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(4, 4))
                        ]),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Get.to(PhotoPreviewScreen(
                        //     userImage:
                        //     controller.mediaImageMessages[index].message));
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                          child: Text(
                            controller.mediaFileMessages[index].type,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ),
                  ),
                );
              }),
        ));
  }
}

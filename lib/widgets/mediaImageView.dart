import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/mediaController.dart';
import 'package:flutter_chat_app/screens/photoPreviewScreen.dart';
import 'package:get/get.dart';

class MediaImageView extends StatelessWidget {
  final MediaController controller;

  const MediaImageView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.readMediaImagesMessages(controller.chatId);
    return Obx(() => Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: GridView.builder(
              itemCount: controller.mediaImageMessages.length,
              physics: BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 15),
              itemBuilder: (context, index) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Get.to(PhotoPreviewScreen(
                          userImage:
                              controller.mediaImageMessages[index].message));
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(4, 4))
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/default.png",
                            fit: BoxFit.cover,
                            image:
                                controller.mediaImageMessages[index].message),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }
}

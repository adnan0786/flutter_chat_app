import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/mediaController.dart';
import 'package:flutter_chat_app/screens/videoPlayerScreen.dart';
import 'package:get/get.dart';

class MediaVideoView extends StatelessWidget {
  final MediaController controller;

  const MediaVideoView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.readMediaVideoMessages(controller.chatId);
    return Obx(() => Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: GridView.builder(
              itemCount: controller.mediaVideoMessages.length,
              physics: BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 15),
              itemBuilder: (context, index) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: FadeInImage.assetNetwork(
                                  placeholder: "assets/images/default.png",
                                  fit: BoxFit.cover,
                                  image: controller
                                      .mediaVideoMessages[index].thumbnail),
                              // child: FadeInImage.assetNetwork(
                              //     placeholder: "assets/images/default.png",
                              //     image:),
                            ),
                          ),
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Get.to(
                                      VideoPlayerScreen(
                                        chatMessageModel: controller
                                            .mediaVideoMessages[index],
                                      ),
                                      transition: Transition.rightToLeft);
                                },
                                child: Icon(
                                  Icons.play_arrow,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ));
  }
}

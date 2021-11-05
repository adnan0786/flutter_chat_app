import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/mediaController.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MediaAudioView extends StatelessWidget {
  final MediaController controller;
  final Function(MessageModel) callback;

  const MediaAudioView(
      {Key? key, required this.controller, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.readMediaAudioMessages(controller.chatId);
    return Obx(() => Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: GridView.builder(
              itemCount: controller.mediaAudioMessages.length,
              physics: BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 15),
              itemBuilder: (context, index) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      callback(controller.mediaAudioMessages[index]);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(4, 4))
                          ]),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                          ),
                          Text(
                              DateFormat("HH:MM a").format(controller
                                  .mediaAudioMessages[index].date
                                  .toDate()),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w400))
                        ]),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }
}

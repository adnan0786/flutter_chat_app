import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/messageController.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:get/get.dart';

class AudioMessageView extends StatelessWidget {
  final MessageModel messageModel;
  final String myId;

  const AudioMessageView(
      {Key? key, required this.messageModel, required this.myId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!messageModel.read && messageModel.sender != myId)
      Get.find<MessageController>().readMessage(messageModel.id);
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      padding: EdgeInsets.only(left: 0, right: 10, top: 5, bottom: 5),
      child: Align(
        alignment: (messageModel.sender != myId
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).disabledColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(4, 4))
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft:
                    Radius.circular(messageModel.sender != myId ? 0 : 30),
                bottomRight:
                    Radius.circular(messageModel.sender != myId ? 30 : 0)),
            color: messageModel.sender != myId
                ? Colors.grey.shade200
                : Theme.of(context).primaryColor.withOpacity(0.2),
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  child: SoundPlayerUI.fromLoader(
                    (context) {
                      return Future.value(
                          Track(trackPath: messageModel.message));
                    },
                    backgroundColor: Colors.transparent,
                    iconColor: Theme.of(context).primaryColor,
                    disabledIconColor: messageModel.sender != myId
                        ? Colors.black
                        : Colors.white,
                    sliderThemeData: SliderThemeData(),
                    textStyle: TextStyle(
                        color: messageModel.sender != myId
                            ? Colors.black
                            : Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

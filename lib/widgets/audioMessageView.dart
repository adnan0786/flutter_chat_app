import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/messageController.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:get/get.dart';

import '../appTheme.dart';

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
      padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
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
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft:
                    Radius.circular(messageModel.sender != myId ? 0 : 20),
                bottomRight:
                    Radius.circular(messageModel.sender != myId ? 20 : 0)),
            color: messageModel.sender != myId
                ? Colors.grey.shade200
                : Theme.of(context).primaryColor.withOpacity(0.2),
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(
                Icons.play_arrow,
                color:
                    messageModel.sender != myId ? Colors.white : kPrimaryColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding / 2),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: messageModel.sender != myId
                            ? Colors.white
                            : kPrimaryColor.withOpacity(0.4),
                      ),
                      Positioned(
                        left: 0,
                        child: Container(
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            color: messageModel.sender != myId
                                ? Colors.white
                                : kPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Text(
                "0.37",
                style: TextStyle(
                    fontSize: 12,
                    color: messageModel.sender != myId ? Colors.white : null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

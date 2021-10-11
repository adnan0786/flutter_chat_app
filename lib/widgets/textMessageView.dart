import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/messageController.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';

class TextMessageView extends StatelessWidget {
  final MessageModel chatMessageModel;
  final ValueChanged<MessageModel> onSwipedMessage;
  final String myId;

  const TextMessageView(
      {Key? key,
      required this.chatMessageModel,
      required this.onSwipedMessage,
      required this.myId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!chatMessageModel.read && chatMessageModel.sender != myId)
      Get.find<MessageController>().readMessage(chatMessageModel.id);
    return SwipeTo(
      onRightSwipe: () => onSwipedMessage(chatMessageModel),
      child: Container(
        padding: EdgeInsets.only(left: 0, right: 10, top: 4, bottom: 4),
        child: Align(
          alignment: (chatMessageModel.sender != myId
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
                      Radius.circular(chatMessageModel.sender != myId ? 0 : 20),
                  bottomRight: Radius.circular(
                      chatMessageModel.sender != myId ? 20 : 0)),
              color: (chatMessageModel.sender != myId
                  ? Colors.grey.shade200
                  : Theme.of(context).primaryColor),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chatMessageModel.message,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: (chatMessageModel.sender != myId
                        ? Colors.black
                        : Colors.white),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (chatMessageModel.star)
                      Icon(
                        Icons.star_rounded,
                        color: Color(0xffffdf00),
                        size: 10,
                      ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      DateFormat("HH:MM a")
                          .format(chatMessageModel.date.toDate()),
                      style: TextStyle(
                          color: (chatMessageModel.sender != myId
                              ? Colors.black
                              : Colors.white),
                          fontSize: 8,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    chatMessageModel.read
                        ? Icon(Icons.done_all,
                            color: Color(0xffffdf00), size: 11)
                        : Icon(Icons.check,
                            color: (chatMessageModel.sender != myId
                                ? Colors.black
                                : Colors.white),
                            size: 10)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

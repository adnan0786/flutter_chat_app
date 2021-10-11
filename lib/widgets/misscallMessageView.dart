import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:intl/intl.dart';

class MissCallMessageView extends StatelessWidget {
  final MessageModel messageModel;
  final String myId;

  const MissCallMessageView(
      {Key? key, required this.messageModel, required this.myId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 40),
      child: Container(
        padding: EdgeInsets.only(left: 35, right: 35, top: 6, bottom: 6),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).disabledColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(4, 4))
              ]),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  messageModel.thumbnail == "video"
                      ? Icons.missed_video_call_rounded
                      : Icons.phone_missed_rounded,
                  color: Colors.white,
                  size: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "${messageModel.message}  ${DateFormat("HH:mm a").format(messageModel.date.toDate())}",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    color: Colors.indigo,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                // Text(),
                // style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

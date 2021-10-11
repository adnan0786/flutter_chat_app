import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/messageController.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VideoMessageView extends StatelessWidget {
  final MessageModel chatMessageModel;
  final String myId;
  final VoidCallback onImageClick;

  const VideoMessageView(
      {Key? key,
      required this.chatMessageModel,
      required this.myId,
      required this.onImageClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!chatMessageModel.read && chatMessageModel.sender != myId)
      Get.find<MessageController>().readMessage(chatMessageModel.id);
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
      child: Align(
        alignment: (chatMessageModel.sender != myId
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Container(
          width: 250,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Theme.of(context).disabledColor.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(4, 4))
          ]),
          child: AspectRatio(
            aspectRatio: 1.1,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/default.png",
                      fit: BoxFit.cover,
                      image: chatMessageModel.thumbnail),
                  // child: FadeInImage.assetNetwork(
                  //     placeholder: "assets/images/default.png",
                  //     image:),
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
                        onImageClick();
                      },
                      child: Icon(
                        Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (chatMessageModel.star)
                          Icon(
                            Icons.star_rounded,
                            color: Color(0xffffdf00),
                            size: 15,
                          ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          DateFormat("HH:MM a")
                              .format(chatMessageModel.date.toDate()),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )
                        ,
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
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

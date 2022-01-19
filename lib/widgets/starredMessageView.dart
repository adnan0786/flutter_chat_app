import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';

class StarredMessageView extends StatelessWidget {
  final MessageModel chatMessageModel;
  final String myId, myImage, userImage;

  const StarredMessageView({
    Key? key,
    required this.chatMessageModel,
    required this.myId,
    required this.myImage,
    required this.userImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(60.0)),
                child: FadeInImage.assetNetwork(
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                  placeholder: "assets/images/default.png",
                  image: myId == chatMessageModel.sender ? myImage : userImage,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Text(
                "Muhammad Adnan",
                style: TextStyle(fontWeight: FontWeight.w500),
              )),
              Text(
                timeAgo(chatMessageModel.date.toDate(), numericDates: false),
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 50),
            child: Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: chatMessageModel.sender == myId
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade200,
                    boxShadow: [
                      BoxShadow(
                          color:
                              Theme.of(context).disabledColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(4, 4))
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Text(
                    chatMessageModel.message,
                    style: TextStyle(
                        color: chatMessageModel.sender == myId
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
    // return Container(
    //   padding: EdgeInsets.only(left: 0, right: 10, top: 4, bottom: 4),
    //   child: Align(
    //     alignment: (chatMessageModel.sender != myId
    //         ? Alignment.topLeft
    //         : Alignment.topRight),
    //     child: Container(
    //       decoration: BoxDecoration(
    //         boxShadow: [
    //           BoxShadow(
    //               color: Theme.of(context).disabledColor.withOpacity(0.1),
    //               blurRadius: 10,
    //               offset: Offset(4, 4))
    //         ],
    //         borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(20),
    //             topRight: Radius.circular(20),
    //             bottomLeft:
    //                 Radius.circular(chatMessageModel.sender != myId ? 0 : 20),
    //             bottomRight:
    //                 Radius.circular(chatMessageModel.sender != myId ? 20 : 0)),
    //         color: (chatMessageModel.sender != myId
    //             ? Colors.grey.shade200
    //             : Theme.of(context).primaryColor),
    //       ),
    //       padding: EdgeInsets.all(10),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Text(
    //             chatMessageModel.message,
    //             style: TextStyle(
    //               fontSize: 16,
    //               fontWeight: FontWeight.w400,
    //               color: (chatMessageModel.sender != myId
    //                   ? Colors.black
    //                   : Colors.white),
    //             ),
    //           ),
    //           Row(
    //             mainAxisSize: MainAxisSize.min,
    //             mainAxisAlignment: MainAxisAlignment.end,
    //             children: [
    //               if (chatMessageModel.star)
    //                 Icon(
    //                   Icons.star_rounded,
    //                   color: Color(0xffffdf00),
    //                   size: 10,
    //                 ),
    //               SizedBox(
    //                 width: 2,
    //               ),
    //               Text(
    //                 DateFormat("HH:MM a")
    //                     .format(chatMessageModel.date.toDate()),
    //                 style: TextStyle(
    //                     color: (chatMessageModel.sender != myId
    //                         ? Colors.black
    //                         : Colors.white),
    //                     fontSize: 8,
    //                     fontWeight: FontWeight.w400),
    //               ),
    //               SizedBox(
    //                 width: 2,
    //               ),
    //               chatMessageModel.read
    //                   ? Icon(Icons.done_all, color: Color(0xffffdf00), size: 11)
    //                   : Icon(Icons.check,
    //                       color: (chatMessageModel.sender != myId
    //                           ? Colors.black
    //                           : Colors.white),
    //                       size: 10)
    //             ],
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

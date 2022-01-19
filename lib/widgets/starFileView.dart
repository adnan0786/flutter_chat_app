import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';

class StarFileView extends StatelessWidget {
  final MessageModel chatMessageModel;
  final String myId, myImage, userImage;

  const StarFileView({
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    image:
                    myId == chatMessageModel.sender ? myImage : userImage),
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
            padding: EdgeInsets.only(left: 50, right: 10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 60,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: chatMessageModel.type == "pdf"
                          ? Colors.red
                          : chatMessageModel.type == "docx"
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
                  child: Center(
                    child: Text(
                      chatMessageModel.type,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';

class StarImageView extends StatelessWidget {
  final MessageModel chatMessageModel;
  final String myId, myImage, userImage;

  const StarImageView({
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
            padding: EdgeInsets.only(left: 50),
            child: Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).disabledColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(4, 4))
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/default.png",
                    fit: BoxFit.cover,
                    image: chatMessageModel.message),
              ),
            ),
          )
        ],
      ),
    );
  }
}

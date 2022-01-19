import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/callDetailModel.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class CallView extends StatelessWidget {
  final CallDetailModel detailModel;
  final String myId;

  const CallView({Key? key, required this.detailModel, required this.myId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(detailModel.image!),
        maxRadius: 20,
      ),
      title:
          Text(detailModel.type, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Row(
        children: [
          detailModel.type == "video"
              ? Icon(
                  Icons.missed_video_call,
                  color: Colors.grey.shade400,
                  size: 18,
                )
              : Icon(
                  Icons.call_rounded,
                  color: Colors.grey.shade400,
                  size: 18,
                ),
          detailModel.from == myId
              ? Text(
                  "Outgoing".tr,
                )
              : detailModel.picked
                  ? Text("Incoming".tr)
                  : Text("Missed".tr)
        ],
      ),
      trailing: Text(
        timeAgo(detailModel.date.toDate()),
        style: TextStyle(fontSize: 12),
      ),
      dense: true,
      horizontalTitleGap: 15,
    );
  }
}

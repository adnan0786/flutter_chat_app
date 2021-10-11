import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/chatMessageModel.dart';

class NewMessageModel extends StatelessWidget {
  final FocusNode focusNode;
  final String idUser;
  final ChatMessageModel replyMessage;
  final VoidCallback onCancelReply;

  const NewMessageModel(
      {Key? key,
      required this.focusNode,
      required this.idUser,
      required this.replyMessage,
      required this.onCancelReply})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget buildReply() => Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        // child: ReplyMessageWidget(
        //   message: widget.replyMessage,
        //   onCancelReply: widget.onCancelReply,
        // ),
      );
}

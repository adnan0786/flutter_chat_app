import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/controllers/chatController.dart';
import 'package:flutter_chat_app/models/chatModel.dart';
import 'package:flutter_chat_app/models/userModel.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';

class ChatListView extends StatelessWidget {
  final void Function(ChatModel chatModel, String userId) callback;
  final ChatModel chatModel;
  final ChatController chatController;

  const ChatListView(
      {Key? key,
      required this.callback,
      required this.chatController,
      required this.chatModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: chatController.service.getUserInfo(
          chatModel.members[0].toString() == chatController.user.uid
              ? chatModel.members[1]
              : chatModel.members[0]),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return Text("Error : ${snapshot.error}");
        } else {
          if (snapshot.hasData)
            return InkWell(
              onTap: () {
                chatModel.name = snapshot.data!.name;
                chatModel.image = snapshot.data!.image;
                callback(chatModel, snapshot.data!.uId);
              },
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(snapshot.data!.image),
                                  maxRadius: 30,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data!.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          snapshot.data!.typing ==
                                                  chatController.user.uid
                                              ? "typing..."
                                              : chatModel.lastMessage,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade600,
                                              fontWeight:
                                                  // isMessageRead
                                                  //     ? FontWeight.bold
                                                  //     :
                                                  FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              timeAgo(chatModel.lastDate.toDate()),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight:
                                      // isMessageRead ? FontWeight.bold :
                                      FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(90, 0, 0, 0),
                        child: Divider())
                  ],
                ),
              ),
            );
          else
            return Container();
        }
      },
    );
  }
}

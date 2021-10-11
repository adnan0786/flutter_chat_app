import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String chatId, lastMessage;
  List<dynamic> members;
  Timestamp lastDate;
  String? image, name;

  ChatModel(this.chatId, this.lastMessage, this.lastDate, this.members,
      {image = "", name = ""});

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
      json["chatId"], json["lastMessage"], json["lastDate"], json["members"]);

  Map<String, dynamic> toJson() => {
        "chatId": chatId,
        "lastMessage": lastMessage,
        "lastDate": lastDate,
        "members": members,
      };
}

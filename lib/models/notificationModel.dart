import 'dart:convert';

class NotificationModel {
  String chatId, name, image, type, userId;

  NotificationModel(this.chatId, this.name, this.image, this.type, this.userId);

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        json  ["chatId"],
        json["name"],
        json["image"],
        json["type"],
        json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "chatId": chatId,
        "name": name,
        "image": image,
        "type": type,
        "userId": userId
      };

  String toJsonString() => jsonEncode(toJson());
}

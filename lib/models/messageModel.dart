import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String sender, receiver, message, type, thumbnail, id;
  bool read;
  Timestamp date;
  bool star;

  MessageModel(this.id, this.sender, this.receiver, this.message, this.date,
      this.type, this.read, this.star, this.thumbnail);

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        json["id"] == null ? "" : json["id"],
        json["sender"] == null ? "" : json["sender"],
        json["receiver"] == null ? "" : json["receiver"],
        json["message"] == null ? "" : json["message"],
        json["date"] == null ? "" : json["date"],
        json["type"] == null ? "" : json["type"],
        json["read"] == null ? "" : json["read"],
        json["star"] == null ? "" : json["star"],
        json["thumbnail"] == null ? "" : json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender": sender,
        "receiver": receiver,
        "message": message,
        "date": date,
        "type": type,
        "read": read,
        "star": star,
        "thumbnail": thumbnail,
      };
}

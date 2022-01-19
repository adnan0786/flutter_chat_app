import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/status.dart';

class StatusModel {
  String userId, name, image;
  Timestamp lastUpdate;
  List<Status>? stories;

  StatusModel(this.lastUpdate, this.userId, this.name, this.image);

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        json["lastUpdate"],
        json["userId"],
        json["name"],
        json["image"],
      );

  Map<String, dynamic> toJson() => {
        "lastUpdate": lastUpdate,
        "userId": userId,
        "name": name,
        "image": image,
      };
}

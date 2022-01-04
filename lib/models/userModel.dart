import 'dart:convert';

import 'package:flutter_chat_app/models/statusModel.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.uId,
    required this.name,
    required this.image,
    required this.number,
    required this.status,
    required this.typing,
    required this.online,
  });

  String uId;
  String name;
  String image;
  String number;
  String status;
  String typing;
  String online;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uId: json["uID"],
        name: json["name"],
        image: json["image"],
        number: json["number"],
        status: json["status"],
        typing: json["typing"],
        online: json["online"],
      );

  Map<String, dynamic> toJson() => {
        "uID": uId,
        "name": name,
        "image": image,
        "number": number,
        "status": status,
        "typing": typing,
        "online": online,
      };
}

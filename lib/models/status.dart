import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  String image, type, id;
  Timestamp date;
  List members;
  int? seenStatus;

  Status(this.image, this.date, this.type, this.id, this.members);

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        json["image"] == null ? "" : json["image"],
        json["date"] == null ? "" : json["date"],
        json["type"] == null ? "" : json["type"],
        json["id"] == null ? "" : json["id"],
        json["members"] as List,
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "date": date,
        "type": type,
        "id": id,
        "members": members.length == 0 ? List.empty() : members,
      };
}

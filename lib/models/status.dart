import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  String image, type,id;
  Timestamp date;

  Status(this.image, this.date, this.type,this.id);

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        json["image"] == null ? "" : json["image"],
        json["date"] == null ? "" : json["date"],
        json["type"] == null ? "" : json["type"],
        json["id"] == null ? "" : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "date": date,
        "type": type,
        "id": id,
      };
}

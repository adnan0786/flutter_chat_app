import 'package:cloud_firestore/cloud_firestore.dart';

class CallDetailModel {
  String id, type, from, to;
  bool picked;
  Timestamp date;

  CallDetailModel(
      this.id, this.type, this.from, this.to, this.picked, this.date);

  factory CallDetailModel.fromJson(Map<String, dynamic> json) =>
      CallDetailModel(
        json["id"],
        json["type"],
        json["from"],
        json["to"],
        json["picked"],
        json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "from": from,
        "to": to,
        "picked": picked,
        "date": date,
      };
}

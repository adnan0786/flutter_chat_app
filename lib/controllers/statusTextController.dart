import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/status.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:get/get.dart';

class StatusTextController extends GetxController {
  TextEditingController numberController = TextEditingController();
  Rx<Color> backgroundColor =
      Rx(Colors.primaries[Random().nextInt(Colors.primaries.length)]);
  String id = "";
  String name = "";
  String image = "";

  FirebaseService service = FirebaseService();

  changeBackgroundColor() {
    backgroundColor.value =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  void addNewStatus() {
    if (numberController.text.isNotEmpty) {
      Status status = Status(numberController.text.trim(), Timestamp.now(),
          "text", "", List.empty());
      service.addNewStatus(status, id, name, image);
      Get.back();
    }
  }
}

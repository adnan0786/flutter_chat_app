import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/status.dart';
import 'package:flutter_chat_app/models/userModel.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:get/get.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

class StatusController extends GetxController {
  RxList<Status> allStatus = RxList(List.empty());
  RxList<StoryItem> storyList = RxList(List.empty());
  RxBool isStory = RxBool(false);
  StoryController storyController = StoryController();
  String image = "";
  String userId = "";
  String name = "";
  Rx<Timestamp> date = Rx<Timestamp>(Timestamp.now());
  String myId = FirebaseAuth.instance.currentUser!.uid;
  FirebaseService service = FirebaseService();

  List<UserModel> statusMembers = [];

  List<Status> get status => allStatus;

  List<StoryItem> get story => storyList;

  arrangeStoryList() {
    status.forEach((element) {
      if (element.type == "image") {
        storyList.add(StoryItem.inlineImage(
          url: element.image,
          controller: storyController,
        ));
      } else {
        storyList.add(StoryItem.text(
          title: element.image,
          backgroundColor: Colors.black,
        ));
      }
    });
  }

  void seenStatus(String statusId, List<dynamic> members) {
    members.add(myId);
    service.seenStatus(members, myId, statusId);
  }

  void getStatusMembers(List<dynamic>? members) {
    if (members != null && members.length > 0) {
      statusMembers.clear();
      members.forEach((element) async {
        var member = await service.getStatusMemberDetail(element.toString());
        statusMembers.add(member);
      });
    }
  }
}

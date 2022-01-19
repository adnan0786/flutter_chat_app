import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/models/callDetailModel.dart';
import 'package:flutter_chat_app/models/userModel.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:get/get.dart';

class CallHistoryController extends GetxController {
  RxList<CallDetailModel> callHistory = RxList(List.empty());
  FirebaseService service = FirebaseService();
  String myId = FirebaseAuth.instance.currentUser!.uid;

  List<CallDetailModel> get callList => callHistory;

  @override
  void onInit() {
    super.onInit();

    service.getCallHistory().listen((event) {
      event.forEach((element) async {
        if (element.from != myId) {
          UserModel user = await service.getStatusMemberDetail(element.from);
          element.image = user.image;
          callHistory.add(element);
        } else {
          UserModel user = await service.getStatusMemberDetail(element.to);
          element.image = user.image;
          callHistory.add(element);
        }

      });
    });
    // callHistory.bindStream(service.getCallHistory());
  }
}

import 'package:flutter_chat_app/models/channelDetailModel.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:flutter_chat_app/screens/videoCallScreen.dart';
import 'package:get/get.dart';

class CallService extends GetxService {
  FirebaseService service = FirebaseService();
  RxList<ChannelDetailModel> chatMessages = RxList();

  @override
  void onInit() {
    super.onInit();

    service.getCallInfo().listen((event) {
      if (event.isNotEmpty) {
        if (!event["isAvailable"]) {
          Get.to(VideoCallScreen(),
              arguments: [true, event["type"], event["chatId"]]);
        }
      }
    });
  }

  Future<CallService> init() async {
    return this;
  }
}

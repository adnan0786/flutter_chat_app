import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/callController.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:get/get.dart';

class VideoCallScreen extends GetView<CallController> {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CallController());
    if (Get.arguments[0] is bool) {
      controller.callType = Get.arguments[1];
      controller.chatId = Get.arguments[2];
      controller.pickCall();
    } else {
      controller.chatId = Get.arguments[0];
      controller.userId = Get.arguments[1];
      controller.callType = Get.arguments[2];
      if (controller.callType == "audio") {
        controller.createAudioChannel();
        controller.localUserAudio(true);
      } else {
        controller.createVideoChannel();
        controller.localUserVideo(true);
      }
    }

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Agora Video Call'),
        ),
        body: Stack(
          children: [
            Positioned(
                top: 0, left: 0, right: 0, bottom: 0, child: _remoteVideo()),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  padding: EdgeInsets.all(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          if (controller.localUserJoined.value) {
                            if (controller.localUserVideo.value)
                              controller.disableVideo();
                            else
                              controller.enabledVideo();
                          }
                        },
                        child: Center(
                          child: Icon(
                            controller.localUserVideo.value
                                ? Icons.videocam_off_rounded
                                : Icons.videocam_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          controller.closeCall();
                        },
                        backgroundColor: Colors.red,
                        child: Center(
                          child: Icon(
                            Icons.call_end_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          if (controller.localUserJoined.value) {
                            if (controller.localUserAudio.value)
                              controller.disableAudio();
                            else
                              controller.enabledAudio();
                          }
                        },
                        child: Center(
                          child: Icon(
                            controller.localUserAudio.value
                                ? Icons.mic_off_rounded
                                : Icons.mic_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      );
    });
  }

  Widget _remoteVideo() {
    if (controller.remoteUid.value != 0) {
      if (controller.remoteUserVideo.value) {
        return RtcRemoteView.SurfaceView(uid: controller.remoteUid.value);
      } else {
        return FadeInImage.assetNetwork(
            placeholder: "assets/images/default.png",
            fit: BoxFit.cover,
            image: "https://randomuser.me/api/portraits/men/9.jpg");
      }
    } else {
      return FadeInImage.assetNetwork(
          placeholder: "assets/images/default.png",
          fit: BoxFit.cover,
          image: "https://randomuser.me/api/portraits/men/9.jpg");
    }
  }
}

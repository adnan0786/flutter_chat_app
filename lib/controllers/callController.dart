import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/appConstants.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:permission_handler/permission_handler.dart';

class CallController extends GetxController {
  RtcEngine? engine;
  RxInt remoteUid = RxInt(0);
  RxBool localUserJoined = RxBool(false);
  FirebaseService service = FirebaseService();
  late String userId, chatId;
  bool isUserPickCall = false;
  String callType = "audio";
  RxBool remoteUserAudio = RxBool(false);
  RxBool remoteUserVideo = RxBool(false);
  RxBool localUserVideo = RxBool(false);
  RxBool localUserAudio = RxBool(false);

  OverlayEntry? entry;
  final overlay = Overlay.of(Get.context!);
  Offset offset = Offset(20, 40);

  @override
  void onInit() {
    super.onInit();
    entry = OverlayEntry(
        builder: (context) => Positioned(
              left: offset.dx,
              top: offset.dy,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    offset += details.delta;
                    entry?.markNeedsBuild();
                  },
                  child: Container(
                    width: 100,
                    height: 150,
                    decoration: BoxDecoration(
                        color: localUserJoined.value
                            ? Colors.transparent
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: localUserJoined.value
                          ? RtcLocalView.SurfaceView()
                          : CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ));
  }

  void createVideoChannel() async {
    await [Permission.microphone, Permission.camera].request();

    engine = await RtcEngine.create(AppConstants.APP_ID);
    await engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine?.setClientRole(ClientRole.Broadcaster);
    await engine?.enableAudio();
    await engine?.enableVideo();
    await engine?.startPreview();

    initEventHandler();

    ChannelMediaOptions options = ChannelMediaOptions(
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishLocalAudio: true,
        publishLocalVideo: true);

    await engine?.joinChannel(
        AppConstants.Token, AppConstants.CHANNEL_NAME, null, 0, options);

    bool isCallSend = await service.callToUser(userId, callType, chatId);
    if (!isCallSend) {
      showErrorSnackBar(
          Get.context!, "User is busy in other call", "User busy", true);
      Get.back();
    }
  }

  void createAudioChannel() async {
    await [Permission.microphone].request();

    engine = await RtcEngine.create(AppConstants.APP_ID);
    await engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine?.setClientRole(ClientRole.Broadcaster);
    await engine?.enableAudio();

    initEventHandler();

    ChannelMediaOptions options = ChannelMediaOptions(
      autoSubscribeAudio: true,
      publishLocalAudio: true,
    );

    await engine?.joinChannel(
        AppConstants.Token, AppConstants.CHANNEL_NAME, null, 0, options);

    bool isCallSend = await service.callToUser(userId, callType, chatId);
    if (!isCallSend) {
      showErrorSnackBar(
          Get.context!, "User is busy in other call", "User busy", true);
      Get.back();
    }
  }

  void pickCall() async {
    await [Permission.microphone, Permission.camera].request();
    ChannelMediaOptions options;
    engine = await RtcEngine.create(AppConstants.APP_ID);
    await engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine?.setClientRole(ClientRole.Broadcaster);
    await engine?.enableAudio();

    if (callType == "video") {
      await engine?.enableVideo();
      await engine?.startPreview();
    }
    initEventHandler();

    if (callType == "video")
      options = ChannelMediaOptions(
          autoSubscribeVideo: true,
          autoSubscribeAudio: true,
          publishLocalAudio: true,
          publishLocalVideo: true);
    else
      options = ChannelMediaOptions(
          autoSubscribeAudio: true, publishLocalAudio: true);

    await engine?.joinChannel(
        AppConstants.Token, AppConstants.CHANNEL_NAME, null, 0, options);
  }

  void initEventHandler() {
    engine?.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined  Channel $channel");
          localUserJoined(true);
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          remoteUid(uid);
          isUserPickCall = true;
        },
        userOffline: (int uid, UserOfflineReason reason) async {
          await engine?.leaveChannel();
        },
        userMuteVideo: (int uId, bool enabled) {
          remoteUserVideo(enabled);
          remoteUid(uId);
        },
        userMuteAudio: (int uId, bool enabled) {
          remoteUserAudio(enabled);
        },
      ),
    );
  }

  void enabledVideo() async {
    await engine?.enableVideo();
    localUserVideo(true);
    overlay?.insert(entry!);
  }

  void disableVideo() async {
    await engine?.disableVideo();
    localUserVideo(false);
    entry?.remove();
  }

  void enabledAudio() async {
    await engine?.enableAudio();
    localUserAudio(true);
  }

  void disableAudio() async {
    await engine?.disableAudio();
    localUserAudio(false);
  }

  void closeCall() async {
    await engine?.leaveChannel();
    service.setTokenAvailability(true);
    service.setUserAvailability(true, userId, "", "");
    Get.back();
  }

  @override
  void onClose() {
    super.onClose();
    if (!isUserPickCall) {
      String msg =
          callType == "audio" ? "Missed voice call" : "Missed video call";
      MessageModel messageModel = MessageModel(
          "id",
          FirebaseAuth.instance.currentUser!.uid,
          userId,
          msg,
          Timestamp.now(),
          "call",
          false,
          false,
          callType);

      service.sendCallMessage(chatId, messageModel);
    }

    entry?.remove();
    entry = null;
  }
}

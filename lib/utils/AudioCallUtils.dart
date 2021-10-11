import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_chat_app/common/appConstants.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioCallUtils {
  late RtcEngine engine;

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    engine = await RtcEngine.create(AppConstants.APP_ID);
    await engine.enableVideo();
    engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
          // setState(() {
          //   _localUserJoined = true;
          // });
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          // setState(() {
          //   _remoteUid = uid;
          // });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          // setState(() {
          //   _remoteUid = null;
          // });
        },
      ),
    );

    await engine.joinChannel(AppConstants.Token, "test", null, 0);
  }
}

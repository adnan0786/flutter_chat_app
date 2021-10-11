import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class MessagePlayerController extends GetxController {
  VideoPlayerController? controller;
  RxBool isPlaying = RxBool(false);
  RxDouble playBackSpeed = RxDouble(1.0);
  RxBool isRepeat = RxBool(false);

  var examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  @override
  void onClose() {
    controller?.dispose();
  }

  initVideoPlayer(String videoUrl) {
    controller = VideoPlayerController.network(videoUrl);

    controller?.addListener(() {
      if (controller!.value.isPlaying)
        isPlaying(true);
      else
        isPlaying(false);
    });
  }

  Future<void> initFuturePlayer() {
    return controller!.initialize();
  }

  void playVideo() {
    controller?.play().then((value) => isPlaying(true));
  }

  void pauseVideo() {
    controller?.pause().then((value) => isPlaying(false));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_app/controllers/videoPlayerController.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends GetView<MessagePlayerController> {
  final MessageModel chatMessageModel;

  VideoPlayerScreen({Key? key, required this.chatMessageModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MessagePlayerController());
    controller.initVideoPlayer(chatMessageModel.message);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Container(
        child: FutureBuilder(
      future: controller.initFuturePlayer(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          controller.playBackSpeed(controller.controller?.value.playbackSpeed);
          return Obx(() {
            return AspectRatio(
              aspectRatio: controller.controller!.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(controller.controller!),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          VideoProgressIndicator(controller.controller!,
                              allowScrubbing: true),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {},
                                        child: PopupMenuButton<double>(
                                          initialValue:
                                              controller.playBackSpeed.value,
                                          tooltip: 'Playback speed',
                                          onSelected: (speed) {
                                            controller.controller!
                                                .setPlaybackSpeed(speed);
                                            controller.playBackSpeed(speed);
                                          },
                                          itemBuilder: (context) {
                                            return [
                                              for (final speed in controller
                                                  .examplePlaybackRates)
                                                PopupMenuItem(
                                                  value: speed,
                                                  child: Text('${speed}x'),
                                                )
                                            ];
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16,
                                            ),
                                            child: Text(
                                              '${controller.playBackSpeed}x',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ))),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      if (controller
                                          .controller!.value.isPlaying) {
                                        controller.pauseVideo();
                                      } else {
                                        controller.playVideo();
                                      }
                                    },
                                    child: controller.isPlaying.value
                                        ? Icon(
                                            Icons.pause_rounded,
                                            size: 60,
                                          )
                                        : Icon(Icons.play_arrow_rounded,
                                            size: 60),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      if (controller
                                          .controller!.value.isLooping) {
                                        controller.controller!
                                            .setLooping(false);
                                        controller.isRepeat(false);
                                      } else {
                                        controller.controller!.setLooping(true);
                                        controller.isRepeat(true);
                                      }
                                    },
                                    child: Icon(
                                        controller.isRepeat.value
                                            ? Icons.repeat_one_rounded
                                            : Icons.repeat_rounded,
                                        size: 30),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          });
        } else {
          return SpinKitRotatingPlain(
            color: Theme.of(context).primaryColor,
          );
        }
      },
    ));
  }
}

class ProgressSeekVideo extends StatelessWidget {
  const ProgressSeekVideo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// class ControlsOverlay extends StatelessWidget {
//   const ControlsOverlay({Key? key, required this.controller})
//       : super(key: key);
//
//   static const _examplePlaybackRates = [
//     0.25,
//     0.5,
//     1.0,
//     1.5,
//     2.0,
//     3.0,
//     5.0,
//     10.0,
//   ];
//
//   final VideoPlayerController controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AnimatedSwitcher(
//           duration: Duration(milliseconds: 50),
//           reverseDuration: Duration(milliseconds: 200),
//           child: controller.value.isPlaying
//               ? SizedBox.shrink()
//               : Container(
//             color: Colors.black26,
//             child: Center(
//               child: Icon(
//                 Icons.play_arrow,
//                 color: Colors.white,
//                 size: 100.0,
//               ),
//             ),
//           ),
//         ),
//         GestureDetector(
//           onTap: () {
//             controller.value.isPlaying ? controller.pause() : controller.play();
//           },
//         ),
//         // Align(
//         //   alignment: Alignment.topRight,
//         //   child: PopupMenuButton<double>(
//         //     initialValue: controller.value.playbackSpeed,
//         //     tooltip: 'Playback speed',
//         //     onSelected: (speed) {
//         //       controller.setPlaybackSpeed(speed);
//         //     },
//         //     itemBuilder: (context) {
//         //       return [
//         //         for (final speed in _examplePlaybackRates)
//         //           PopupMenuItem(
//         //             value: speed,
//         //             child: Text('${speed}x'),
//         //           )
//         //       ];
//         //     },
//         //     child: Padding(
//         //       padding: const EdgeInsets.symmetric(
//         //         // Using less vertical padding as the text is also longer
//         //         // horizontally, so it feels like it would need more spacing
//         //         // horizontally (matching the aspect ratio of the video).
//         //         vertical: 12,
//         //         horizontal: 16,
//         //       ),
//         //       child: Text('${controller.value.playbackSpeed}x'),
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }
// }

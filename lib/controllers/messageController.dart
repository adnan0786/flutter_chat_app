import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/appConstants.dart';
import 'package:flutter_chat_app/common/appPermissions.dart';
import 'package:flutter_chat_app/models/chatMessageModel.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:flutter_chat_app/models/userModel.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';
import 'package:flutter_chat_app/utils/soundRecorder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';

class MessageController extends GetxController {
  var massageController = TextEditingController();
  var focusNode = FocusNode();
  SoundRecording? soundRecording;
  String? chatId;
  String path = "";

  Timer? _ticker;
  FirebaseService service = FirebaseService();
  late ChatMessageModel replyMessage;
  final appPermissions = AppPermissions();
  String myId = FirebaseAuth.instance.currentUser!.uid;
  String myName = FirebaseAuth.instance.currentUser!.displayName!;
  ScrollController scrollController = new ScrollController();
  var userModel = UserModel(
          uId: "uId",
          name: 'name',
          image: "image",
          number: 'number',
          status: 'status',
          typing: "false",
          online: DateTime.now().toString())
      .obs;

  UserModel get user => userModel.value;
  RxBool isTyping = RxBool(true);
  RxBool isRecording = RxBool(true);
  RxList<MessageModel> chatMessages = RxList();
  RxInt _audioTime = RxInt(0);

  List<MessageModel> get messages => chatMessages;

  int get time => _audioTime.value;

  @override
  void onInit() async {
    soundRecording = SoundRecording();
    await soundRecording?.init();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    massageController.dispose();
    soundRecording?.stop();
    soundRecording = null;
  }

  void showPicker(context) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: new Wrap(
            children: <Widget>[
              ListTile(
                  leading: new Icon(Icons.photo_library_rounded,
                      color: Theme.of(context).primaryColor),
                  title: new Text('Photo Library'),
                  onTap: () async {
                    Navigator.pop(context);
                    var status = await Permission.manageExternalStorage.status;
                    switch (status) {
                      case PermissionStatus.denied:
                        var status = await Permission.manageExternalStorage
                            .request()
                            .isGranted;
                        if (!status) {
                          showErrorSnackBar(
                              context,
                              "Storage Permission Denied",
                              "Permission Denied",
                              true);
                        } else {
                          getImage(ImageSource.gallery);
                        }
                        break;
                      case PermissionStatus.granted:
                        getImage(ImageSource.gallery);

                        break;
                      case PermissionStatus.restricted:
                        showErrorSnackBar(context, "Your device not supported",
                            " Storage Permission", true);
                        break;
                      case PermissionStatus.limited:
                        showErrorSnackBar(
                            context,
                            "Application has limited access",
                            "Limited Access",
                            true);
                        break;
                      case PermissionStatus.permanentlyDenied:
                        await openAppSettings();
                        break;
                    }
                  }),
              ListTile(
                leading: new Icon(
                  Icons.photo_camera_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                title: new Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  var status = await appPermissions.cameraPermission();
                  switch (status) {
                    case PermissionStatus.denied:
                      var status = await Permission.camera.request().isGranted;
                      if (!status) {
                        showErrorSnackBar(context, "Camera Permission Denied",
                            "Permission Denied", true);
                      } else {
                        getImage(ImageSource.camera);
                      }
                      break;
                    case PermissionStatus.granted:
                      getImage(ImageSource.camera);

                      break;
                    case PermissionStatus.restricted:
                      showErrorSnackBar(context, "Your device not supported",
                          "Permission Error", true);
                      break;
                    case PermissionStatus.limited:
                      showErrorSnackBar(
                          context,
                          "Application has limited access",
                          "Limited Access",
                          true);
                      break;
                    case PermissionStatus.permanentlyDenied:
                      await openAppSettings();
                      break;
                  }
                },
              ),
              ListTile(
                leading: new Icon(
                  Icons.contact_phone_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                title: new Text('Contact'),
                onTap: () async {
                  Navigator.pop(context);
                  showErrorSnackBar(context, "Contact", "Pick Contact", false);
                },
              ),
              ListTile(
                leading: new Icon(
                  Icons.location_on_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                title: new Text('Location'),
                onTap: () async {
                  Navigator.pop(context);
                  showErrorSnackBar(
                      context, "Location", "Pick Location", false);
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  void checkChatExist() async {
    try {
      chatId = await service.isChatExist(userModel.value.uId);
      if (chatId!.isNotEmpty) {
        readChatMessages(chatId!);
        printInfo(info: chatId!);
      }
    } on Exception catch (e) {
      showErrorSnackBar(Get.context!, e.toString(), "Chat Error", true);
    }
  }

  void sendTextMessage(MessageModel messageModel) {
    service.sendTextMessage(chatId!, messageModel);
    massageController.text = "";
    focusNode.unfocus();
    service.getToken(user.uId).then((token) {
      if (token != null && token.isNotEmpty) {
        Map<String, dynamic> map = Map();
        map["chatId"] = chatId;
        map["name"] = user.name;
        map["image"] = user.image;
        map["type"] = AppConstants.textNotification;
        service.sendPushMessage(myName, messageModel.message, map, token);
      }
    });
  }

  void checkUserUpdates() {
    userModel.bindStream(service.userUpdates(userModel.value.uId));
  }

  void createChat(MessageModel messageModel) async {
    chatId = await service.createChat(userModel.value.uId);
    readChatMessages(chatId!);
    sendTextMessage(messageModel);
  }

  void readChatMessages(String chatId) {
    chatMessages.bindStream(service.getChatMessages(chatId));
  }

  void getImage(ImageSource source) async {
    switch (source) {
      case ImageSource.camera:
        File file = await imgFromCamera(false);
        service.sendPhotoMessage(
            chatId!,
            MessageModel("", myId, userModel.value.uId, 'message',
                Timestamp.now(), "image", false, false, ""),
            file);
        break;

      case ImageSource.gallery:
        File file = await imgFromGallery(false);
        service.sendPhotoMessage(
            chatId!,
            MessageModel("", myId, userModel.value.uId, 'message',
                Timestamp.now(), "image", false, false, ""),
            file);
        break;
    }
  }

  void pickVideo(context) async {
    var status = await appPermissions.storagePermission();
    switch (status) {
      case PermissionStatus.denied:
        var status = await Permission.storage.request().isGranted;
        if (!status) {
          showErrorSnackBar(
              context, "Storage Permission Denied", "Permission Denied", true);
        } else {
          _getVideo(ImageSource.gallery);
        }
        break;
      case PermissionStatus.granted:
        _getVideo(ImageSource.gallery);

        break;
      case PermissionStatus.restricted:
        showErrorSnackBar(
            context, "Your device not supported", " Storage Permission", true);
        break;
      case PermissionStatus.limited:
        showErrorSnackBar(
            context, "Application has limited access", "Limited Access", true);
        break;
      case PermissionStatus.permanentlyDenied:
        await openAppSettings();
        break;
    }
  }

  void recordVideo(context) async {
    var status = await appPermissions.cameraPermission();
    switch (status) {
      case PermissionStatus.denied:
        var status = await Permission.camera.request().isGranted;
        if (!status) {
          showErrorSnackBar(
              context, "Camera Permission Denied", "Permission Denied", true);
        } else {
          _getVideo(ImageSource.camera);
        }
        break;
      case PermissionStatus.granted:
        _getVideo(ImageSource.camera);

        break;
      case PermissionStatus.restricted:
        showErrorSnackBar(
            context, "Your device not supported", " Camera Permission", true);
        break;
      case PermissionStatus.limited:
        showErrorSnackBar(
            context, "Application has limited access", "Limited Access", true);
        break;
      case PermissionStatus.permanentlyDenied:
        await openAppSettings();
        break;
    }
  }

  _getVideo(ImageSource source) async {
    switch (source) {
      case ImageSource.camera:
        File videoFile = await videoFromCamera();
        MediaInfo? mediaInfo = await getCompressedVideo(videoFile);
        var result = await generateThumbnail(mediaInfo!.file);

        service.sendVideoMessage(
            chatId!,
            MessageModel("", myId, userModel.value.uId, 'message',
                Timestamp.now(), "video", false, false, result!.path),
            mediaInfo.file!);
        break;

      case ImageSource.gallery:
        File videoFile = await videoFromGallery();
        MediaInfo? mediaInfo = await getCompressedVideo(videoFile);
        var result = await generateThumbnail(mediaInfo!.file);
        service.sendVideoMessage(
            chatId!,
            MessageModel("", myId, userModel.value.uId, 'message',
                Timestamp.now(), "video", false, false, result!.path),
            mediaInfo.file!);
        break;
    }
  }

  void startRecording() {
    if (!isDirectoryExist("ChatApp/media/audio"))
      createDirectory("ChatApp/media/audio");

    path = Directory("ChatApp/media/audio/${DateTime.now()}").path;
    startTimer();
    soundRecording?.start(path);
  }

  void stopRecording() {
    _ticker?.cancel();
    soundRecording?.stop();
  }

  void startTimer() {
    _ticker = Timer.periodic(Duration(seconds: 1), (timer) {
      _audioTime(timer.tick);
    });
  }

  void addStartMessage(
    String messageId,
    bool star,
  ) {
    service.addStartMessage(messageId, star, chatId!);
  }

  void readMessage(String messageId) {
    service.readMessage(messageId, chatId!);
  }
}

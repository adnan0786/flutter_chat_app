import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/appConstants.dart';
import 'package:flutter_chat_app/common/appPermissions.dart';
import 'package:flutter_chat_app/models/chatMessageModel.dart';
import 'package:flutter_chat_app/models/locationModel.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:flutter_chat_app/models/userModel.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:flutter_chat_app/screens/locationPickerScreen.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';
import 'package:flutter_chat_app/utils/soundRecorder.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';

class MessageController extends GetxController
    with SingleGetTickerProviderMixin {
  var massageController = TextEditingController();
  var focusNode = FocusNode();
  SoundRecording? soundRecording;
  String? chatId;
  String path = "";
  RxString typing = RxString("");
  late final AnimationController controller;

  Timer? _ticker;
  FirebaseService service = FirebaseService();
  late ChatMessageModel replyMessage;
  AppPermissions appPermissions = AppPermissions();
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
          online: "true")
      .obs;

  UserModel get user => userModel.value;
  RxBool isTyping = RxBool(true);
  RxBool isRecording = RxBool(true);
  RxList<MessageModel> chatMessages = RxList();
  RxInt _audioTime = RxInt(0);
  late Animation<int> animation;

  List<MessageModel> get messages => chatMessages;

  int get time => _audioTime.value;

  @override
  void onInit() {
    soundRecording = SoundRecording();
    soundRecording?.init();
    controller = AnimationController(
      lowerBound: 35,
      upperBound: 55,
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    animation = Tween<int>(begin: 35, end: 55).animate(controller);
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    massageController.dispose();
    soundRecording?.stopRecording();
    soundRecording = null;
    controller.dispose();
    scrollController.dispose();
    soundRecording?.destroy();
    soundRecording?.destroyPlayer();
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
                  Icons.attach_file_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                title: new Text('Documents'),
                onTap: () async {
                  Get.back();
                  pickFile(context);
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
                  pickLocation(context);
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

  void sendLocationMessage(MessageModel messageModel) {
    service.sendTextMessage(chatId!, messageModel);
  }

  void checkUserUpdates() async {
    // controller.user.typing == controller.myId
    //     ? "typing..."
    //     : controller.user.online == "true"
    //     ? "Online"
    // : timeAgo(DateFormat("yyyy-MM-dd hh:mm:ss")
    //     .parse(controller.user.online)

    userModel.bindStream(service.userUpdates(userModel.value.uId));
    userModel.listen((model) {
      model.typing == myId
          ? typing.value = "typing"
          : model.online == "true"
              ? typing.value = "Online"
              : typing.value = "Offline";
    });
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

  void startRecording() async {
    Directory? baseDir = await getApplicationDocumentsDirectory();

    var dir = Directory("${baseDir.path}/ChatApp/media/audio");
    bool dirExists = await dir.exists();
    Directory createdDirec;
    if (!dirExists)
      createdDirec = await dir.create(recursive: true);
    else
      createdDirec = Directory(dir.path);

    path = "${createdDirec.path}/${DateTime.now()}.aac";
    startTimer();
    soundRecording?.startRecording(path);
  }

  void stopRecording() {
    _ticker?.cancel();
    soundRecording?.stopRecording();
    service.sendAudioMessage(
        chatId!,
        MessageModel("", myId, userModel.value.uId, 'message', Timestamp.now(),
            "audio", false, false, ""),
        File(path));
  }

  void startTimer() {
    _audioTime(0);
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

  void startPlayer(String path) async {
    await soundRecording?.startPlayer(path);
  }

  void stopPlayer() async {
    await soundRecording?.stopPlayer();
  }

  void pickLocation(context) async {
    var status = await appPermissions.locationPermission();
    switch (status) {
      case PermissionStatus.denied:
        var status = await Permission.locationAlways.request().isGranted;
        if (!status) {
          showErrorSnackBar(
              context, "Location Permission Denied", "Permission Denied", true);
        } else {
          var result = await Get.to(LocationPickerScreen());
          if (result != null) {
            LatLng selectedLocation = result[0];
            sendLocationMessage(MessageModel(
                "",
                myId,
                user.uId,
                jsonEncode(LocationModel(
                    lat: selectedLocation.latitude,
                    lng: selectedLocation.longitude)),
                Timestamp.now(),
                "location",
                false,
                false,
                ""));
          }
        }
        break;
      case PermissionStatus.granted:
        var result = await Get.to(LocationPickerScreen());
        if (result != null) {
          LatLng selectedLocation = result[0];
          sendLocationMessage(MessageModel(
              "",
              myId,
              user.uId,
              jsonEncode(LocationModel(
                  lat: selectedLocation.latitude,
                  lng: selectedLocation.longitude)),
              Timestamp.now(),
              "location",
              false,
              false,
              ""));
        }

        break;
      case PermissionStatus.restricted:
        showErrorSnackBar(
            context, "Your device not supported", " Location Permission", true);
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

  void pickFile(context) async {
    var status = await appPermissions.storagePermission();
    switch (status) {
      case PermissionStatus.denied:
        var status = await Permission.storage.request().isGranted;
        if (!status) {
          showErrorSnackBar(
              context, "Storage Permission Denied", "Permission Denied", true);
        } else {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowedExtensions: ["pdf", "docx", "txt"], type: FileType.custom);

          if (result != null) {
            File file = File(result.files.single.path!);
            service.sendFileMessage(
                chatId!,
                MessageModel("", myId, user.uId, "", Timestamp.now(),
                    result.files.single.extension!, false, false, ""),
                file);
          }
        }
        break;
      case PermissionStatus.granted:
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            allowedExtensions: ["pdf", "docx", "txt"], type: FileType.custom);
        if (result != null) {
          File file = File(result.files.single.path!);

          service.sendFileMessage(
              chatId!,
              MessageModel(
                  "",
                  myId,
                  user.uId,
                  "",
                  Timestamp.now(),
                  result.files.single.extension!,
                  false,
                  false,
                  result.files.single.name),
              file);
        }

        break;
      case PermissionStatus.restricted:
        showErrorSnackBar(
            context, "Your device not supported", " Location Permission", true);
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

  void deleteMessage(MessageModel messageModel) {
    service.deleteChatMessage(messageModel, chatId!);
  }
}

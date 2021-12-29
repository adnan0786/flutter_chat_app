import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/appPermissions.dart';
import 'package:flutter_chat_app/models/chatModel.dart';
import 'package:flutter_chat_app/models/status.dart';
import 'package:flutter_chat_app/models/statusModel.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:flutter_chat_app/screens/StatusTextScreen.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatController extends GetxController {
  var isLoading = true.obs;
  late Stream<List<ChatModel>> chat;
  FirebaseService service = FirebaseService();
  RxList<ChatModel> userChats = RxList();
  RxList<Status> myStatus = RxList(List.empty());
  RxList<StatusModel> userStatus = RxList(List.empty());
  AppPermissions appPermissions = AppPermissions();

  List<ChatModel> get chats => userChats;

  List<Status> get status => myStatus;
  User user = FirebaseAuth.instance.currentUser!;

  @override
  void onInit() {
    super.onInit();
    userChats.bindStream(service.getChatList());
    myStatus.bindStream(service.getMyStatus(user.uid));
    userStatus.bindStream(service.getAllStatus());
    userStatus.listen((list) {
      printInfo(info: "${list[0].stories!.length}");
    });
  }

  void showPicker(context) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: new Wrap(
            children: <Widget>[
              ListTile(
                leading: new Icon(
                  Icons.edit_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                title: new Text('Text'),
                onTap: () async {
                  Get.back();
                  Get.to(StatusTextScreen(),
                      arguments: [user.uid, user.displayName, user.photoURL]);
                },
              ),
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
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  void getImage(ImageSource source) async {
    switch (source) {
      case ImageSource.camera:
        File file = await imgFromCamera(false);

        break;

      case ImageSource.gallery:
        File file = await imgFromGallery(false);

        break;
    }
  }
}

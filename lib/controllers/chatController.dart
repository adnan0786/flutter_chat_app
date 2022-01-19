import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/appPermissions.dart';
import 'package:flutter_chat_app/models/chatModel.dart';
import 'package:flutter_chat_app/models/status.dart';
import 'package:flutter_chat_app/models/statusModel.dart';
import 'package:flutter_chat_app/models/userModel.dart';
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
  RxList<StatusModel> _userStatus = RxList(List.empty());
  RxList<StatusModel> allStories = RxList(List.empty());
  AppPermissions appPermissions = AppPermissions();
  String myNumber = FirebaseAuth.instance.currentUser!.phoneNumber!;
  var contacts = RxList<UserModel>();

  List<ChatModel> get chats => userChats;

  List<Status> get status => myStatus;
  User user = FirebaseAuth.instance.currentUser!;

  @override
  void onInit() {
    super.onInit();
    getMobileContacts();
    userChats.bindStream(service.getChatList());
    myStatus.bindStream(service.getMyStatus(user.uid));
    _userStatus.bindStream(service.getAllStatus());

    _userStatus.listen((p0) {
      manageStories();
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

  Future<void> getMobileContacts() async {
    var result = await Permission.contacts.status;

    switch (result) {
      case PermissionStatus.denied:
        var status = await Permission.contacts.request().isGranted;
        status
            ? await getContacts()
            : showErrorSnackBar(Get.context!, "Contact Permission Denied",
                "Permission Denied", true);

        break;
      case PermissionStatus.granted:
        await getContacts();
        break;
      case PermissionStatus.restricted:
        showErrorSnackBar(Get.context!, "Your device not supported",
            " Contact Permission", true);
        break;
      case PermissionStatus.limited:
        showErrorSnackBar(Get.context!, "Application has limited access",
            "Limited Access", true);
        break;
      case PermissionStatus.permanentlyDenied:
        await openAppSettings();
        break;
    }
  }

  Future<void> getContacts() async {
    contacts.clear();
    isLoading(true);
    Iterable<Contact> result = await getMobileContact();
    if (result.length > 0) {
      List<UserModel> mobileContact = [];
      result.forEach((element) async {
        String number = element.phones!.elementAt(0).value!;
        number = number.replaceAll(RegExp('\\s'), "");
        if (number[0] == "0")
          number = number.replaceFirst(RegExp("(?:0)"), "+92");

        mobileContact.add(UserModel(
            uId: element.identifier!,
            name: element.displayName!,
            image: element.avatar.toString(),
            number: number,
            status: "",
            typing: "",
            online: ""));
      });
      List<UserModel> appContacts = await service.getAppContacts();
      appContacts.forEach((app) {
        for (var mobile in mobileContact) {
          if (app.number == mobile.number && app.number != myNumber) {
            contacts.add(UserModel(
                uId: app.uId,
                name: mobile.name,
                image: app.image,
                number: app.number,
                status: app.status,
                typing: app.typing,
                online: app.online));
          }
        }
      });
      manageStories();

      isLoading(false);
    } else
      isLoading(false);
  }

  Future<List<Status>> getStories(String userId) {
    return service.getStories(userId);
  }

  void manageStories() {
    allStories.clear();
    contacts.forEach((element) {
      for (var status in _userStatus) {
        if (status.userId.trim() == element.uId.trim()) {
          allStories.add(status);
        }
      }
    });
  }
}

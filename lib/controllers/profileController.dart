import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/appPermissions.dart';
import 'package:flutter_chat_app/models/userModel.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileController extends GetxController {
  final controllerText = TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final appPermissions = AppPermissions();
  FirebaseService firebaseService = FirebaseService();
  final isLoading = RxBool(false);
  final userModel = UserModel(
          uId: "",
          name: "",
          image: "",
          number: "",
          status: "",
          typing: "",
          online: "")
      .obs;

  @override
  void onInit() {
    super.onInit();
    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseAuth.currentUser?.uid)
        .get()
        .then<dynamic>((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        userModel.value =
            UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      }
    });
  }

  void getImage(ImageSource source) async {
    switch (source) {
      case ImageSource.camera:
        File file = await imgFromCamera(true);
        isLoading(true);
        String imagePath = await firebaseService.uploadUserImage(
            "profile/image", firebaseAuth.currentUser!.uid, File(file.path));
        firebaseService.updateImage(imagePath).then((value) {
          isLoading(false);
          userModel.value.image = value;
        }).catchError((error) {
          isLoading(false);
          showErrorSnackBar(
              Get.context!, error.toString(), "Image Error", true);
        });

        break;

      case ImageSource.gallery:
        File file = await imgFromGallery(true);
        isLoading(true);
        String imagePath = await firebaseService.uploadUserImage(
            "profile/image", firebaseAuth.currentUser!.uid, File(file.path));
        userModel.value.image = imagePath;
        isLoading(false);

        break;
    }
  }

  void showPicker(context) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.photo_library,
                      color: Theme.of(context).primaryColor),
                  title: new Text('Photo Library'),
                  onTap: () async {
                    Navigator.pop(context);
                    var status = await appPermissions.storagePermission();
                    switch (status) {
                      case PermissionStatus.denied:
                        var status =
                            await Permission.storage.request().isGranted;
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
              new ListTile(
                leading: new Icon(
                  Icons.photo_camera,
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

  void updateDialog(BuildContext context, String title, bool isName) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "$title",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextField(
                    controller: controllerText,
                    textCapitalization: TextCapitalization.words,
                    cursorColor: Theme.of(context).primaryColor,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      if (controllerText.text.isNotEmpty) {
                        isName
                            ? updateName(controllerText.text.trim(), context)
                            : updateStatus(controllerText.text.trim(), context);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: isName ? "Name" : "Status",
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            controllerText.clear();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () {
                          if (controllerText.text.isNotEmpty) {
                            isName
                                ? updateName(
                                    controllerText.text.trim(), context)
                                : updateStatus(
                                    controllerText.text.trim(), context);
                          }
                        },
                        child: Text(
                          "Update",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void updateName(String name, BuildContext context) {
    controllerText.clear();
    Navigator.pop(context);
    isLoading(true);
    firebaseService.updateName(name).then((value) {
      userModel.value.name = value;
      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      printError(info: e.toString());
      showErrorSnackBar(Get.context!, e.toString(), "Name Error", true);
    });
  }

  void updateStatus(String status, BuildContext context) {
    controllerText.clear();
    Navigator.pop(context);
    isLoading(true);
    firebaseService.updateStatus(status).then((value) {
      userModel.value.status = value;
      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      printError(info: e.toString());
      showErrorSnackBar(Get.context!, e.toString(), "Status Error", true);
    });
  }
}

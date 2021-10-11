import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/appPermissions.dart';
import 'package:flutter_chat_app/main.dart';
import 'package:flutter_chat_app/models/userModel.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:flutter_chat_app/screens/getUserInfoScreen.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginController extends GetxController {
  var loading = RxBool(false);
  var selectedImage = "".obs;
  TextEditingController numberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String code = "+92";
  late String number;
  RxString numberError = RxString("");
  RxString pinError = RxString("");
  RxString nameError = RxString("");
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseService service = FirebaseService();
  final appPermissions = AppPermissions();
  RxBool isLoading = RxBool(false);

  @override
  void onClose() {
    numberController.dispose();
    otpController.dispose();
    nameController.dispose();
    super.onClose();
  }

  void sendOTP() async {
    if (numberController.text.isEmpty) {
      numberError("Field is required");
    } else if (numberController.text.length < 10) {
      numberError("Invalid number");
    } else {
      numberError("");
      isLoading(true);
      number = code + numberController.text;
      await service.sendVerificationCode(number);
      isLoading(false);
    }
  }

  void verifyOTP() async {
    if (otpController.text.isEmpty) {
      pinError("Field is required");
    } else if (otpController.text.length < 6) {
      pinError("Invalid pin");
    } else {
      isLoading(true);
      await service.verifyOTP(otpController.text);
      isLoading(false);
      Get.off(GetUserInfoScreen());
    }
  }

  void getImage(ImageSource source) async {
    switch (source) {
      case ImageSource.camera:
        File file = await imgFromCamera(true);
        selectedImage.value = file.path;
        break;

      case ImageSource.gallery:
        File file = await imgFromGallery(true);
        selectedImage.value = file.path;
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

  void skipInfo() {
    isLoading(true);
    UserModel userModel = UserModel(
        status: "Hey I'm using this application",
        image: '',
        number: number,
        uId: auth.currentUser!.uid,
        name: '',
        typing: "false",
        online: DateTime.now().toString());

    service.createUser(userModel).then((value) => isLoading(false));
    Get.offAllNamed(Routes.DASHBOARD);
  }

  void uploadUserData() async {
    if (nameController.text.isEmpty) {
      nameError("Filed is required");
    } else if (selectedImage.value == "") {
      showErrorSnackBar(
          Get.context!, "Please select image", "Image Error", true);
    } else {
      nameError("");
      isLoading(true);
      String link = await service.uploadUserImage(
          "profile/image", auth.currentUser!.uid, File(selectedImage.value));

      UserModel userModel = UserModel(
          uId: auth.currentUser!.uid,
          name: nameController.text,
          image: link,
          number: number,
          status: "Hey I'm using this application",
          typing: "false",
          online: DateTime.now().toString());

      await service.createUser(userModel).then((value) => isLoading(false));
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }
}

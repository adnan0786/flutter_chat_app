import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/loginController.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class GetUserInfoScreen extends GetView<LoginController> {
  const GetUserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => LoadingOverlay(
          isLoading: controller.isLoading.value,
          progressIndicator: SpinKitRotatingPlain(
            color: Theme.of(context).primaryColor,
          ),
          child: Scaffold(
            body: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: Container(
                      height: AppBar().preferredSize.height,
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.1),
                                offset: Offset(4, 4),
                                blurRadius: 10)
                          ]),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Container(
                              width: AppBar().preferredSize.height - 8,
                              height: AppBar().preferredSize.height - 8,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(32.0),
                                  ),
                                  onTap: () {
                                    // Get.back();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Text(
                            "User_Info".tr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: TextButton(
                                onPressed: () {
                                  controller.skipInfo();
                                }, child: Text("Skip".tr)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, top: 40),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          shape: BoxShape.circle,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .dividerColor,
                                              blurRadius: 8,
                                              offset: Offset(4, 4),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(60.0)),
                                          child: controller
                                                      .selectedImage.value ==
                                                  ""
                                              ? Image.asset(
                                                  "assets/images/verification.jpg")
                                              : Image.file(
                                                  File(controller
                                                      .selectedImage.value),
                                                  fit: BoxFit.cover),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: BoxShape.circle,
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                color: Theme.of(context)
                                                    .dividerColor,
                                                blurRadius: 8,
                                                offset: Offset(4, 4),
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(24.0)),
                                              onTap: () {
                                                controller.showPicker(context);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: Theme.of(context)
                                                      .backgroundColor,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Theme.of(context)
                                                .shadowColor
                                                .withOpacity(0.2),
                                            offset: Offset(4, 4),
                                            blurRadius: 10)
                                      ],
                                      color: Theme.of(context).backgroundColor),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child: Container(
                                      height: 48,
                                      child: Center(
                                        child: TextField(
                                          controller: controller.nameController,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                            errorMaxLines: 1,
                                            contentPadding: EdgeInsets.only(top: 5,bottom: 5),
                                            errorText: controller
                                                    .nameError.value==""
                                                ? null
                                                : controller.nameError.value,
                                            border: InputBorder.none,
                                            hintText: "Username",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, bottom: 30, top: 40),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context)
                                              .disabledColor
                                              .withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: Offset(4, 4))
                                    ],
                                    color: Theme.of(context).primaryColor),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(30),
                                    onTap: () {
                                      controller.uploadUserData();
                                    },
                                    child: Center(
                                      child: Text(
                                        "Submit".tr,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

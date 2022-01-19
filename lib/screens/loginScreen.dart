import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/loginController.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

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
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.1),
                            offset: Offset(4, 4),
                            blurRadius: 10),
                      ], color: Theme.of(context).backgroundColor),
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
                                    Get.back();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.arrow_back_ios,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Text(
                            "Registration".tr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: AspectRatio(
                              aspectRatio: 2,
                              child: Image.asset("assets/images/otp.jpg"),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "One_Time".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, top: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 48,
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
                                  child: CountryCodePicker(
                                    favorite: ["Pakistan"],
                                    closeIcon: Icon(
                                      Icons.close,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    initialSelection: "Pakistan",
                                    textStyle: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onChanged: (countryCode) {
                                      print(
                                          "New Country selected: ${countryCode.dialCode}");
                                      controller.code = countryCode.dialCode!;
                                    },
                                  ),
                                ),
                                SizedBox(width: 20),
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
                                          controller:
                                              controller.numberController,
                                          keyboardType: TextInputType.number,
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                            errorMaxLines: 1,
                                            contentPadding: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            errorText: controller
                                                        .numberError.value ==
                                                    ""
                                                ? null
                                                : controller.numberError.value,
                                            border: InputBorder.none,
                                            hintText: "Number",
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
                                  left: 24, right: 24, top: 40),
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
                                      controller.sendOTP();
                                    },
                                    child: Center(
                                      child: Text(
                                        "Generate OTP".tr,
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

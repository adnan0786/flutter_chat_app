import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/loginController.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:get/get.dart';

class VerificationScreen extends GetView<LoginController> {
  const VerificationScreen({Key? key}) : super(key: key);

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
                                    Get.back();
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
                            "OTP Verification",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: AspectRatio(
                              aspectRatio: 2,
                              child:
                                  Image.asset("assets/images/verification.jpg"),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "Enter OTP sent to +923059048730",
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
                            child: PinInputTextField(
                              controller: controller.otpController,
                              pinLength: 6,
                              textInputAction: TextInputAction.done,
                              decoration: CirclePinDecoration(
                                strokeColorBuilder: FixedColorBuilder(
                                    Theme.of(context).primaryColor),
                                hintText: "359172",
                                errorText: controller.pinError.value == ""
                                    ? null
                                    : controller.pinError.value,
                                strokeWidth: 2,
                                hintTextStyle: TextStyle(
                                    color: Theme.of(context).disabledColor,
                                    fontSize: 20),
                              ),
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
                                      controller.verifyOTP();
                                    },
                                    child: Center(
                                      child: Text(
                                        "Verify OTP",
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

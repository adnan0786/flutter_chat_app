
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/statusTextController.dart';
import 'package:get/get.dart';

class StatusTextScreen extends GetView<StatusTextController> {
  const StatusTextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(StatusTextController());
    var arguments = Get.arguments;
    controller.id = arguments[0];
    controller.name = arguments[1];
    controller.image = arguments[2];
    return Obx(() => Scaffold(
          body: Container(
            height: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  left: 0,
                  child: Container(
                    color: controller.backgroundColor.value,
                  ),
                ),
                TextField(
                  controller: controller.numberController,
                  cursorColor: Colors.white,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                      border: InputBorder.none,
                      hintText: "Type_a_status".tr,
                      hintStyle: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.w500)),
                ),
                Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: SafeArea(
                      child: Container(
                        child: Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  controller.changeBackgroundColor();
                                },
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  child: Icon(
                                    Icons.color_lens,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          controller.addNewStatus();
                        },
                        child: Center(
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

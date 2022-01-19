import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/callHistoryController.dart';
import 'package:flutter_chat_app/widgets/callView.dart';
import 'package:flutter_chat_app/widgets/loadingLayout.dart';
import 'package:get/get.dart';

class CallScreen extends GetView<CallHistoryController> {
  const CallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Calls".tr,
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1?.color,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() => controller.callList.length < 0
          ? LoadingLayout()
          : ListView.separated(
              itemCount: controller.callList.length,
              itemBuilder: (context, index) {
                return CallView(
                    detailModel: controller.callList[index],
                    myId: controller.myId);
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            )),
    );
  }
}

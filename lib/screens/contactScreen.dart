import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/chatController.dart';
import 'package:flutter_chat_app/screens/messageScreen.dart';
import 'package:flutter_chat_app/widgets/contactListView.dart';
import 'package:flutter_chat_app/widgets/loadingLayout.dart';
import 'package:get/get.dart';

class ContactScreen extends GetView<ChatController> {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            "Contact".tr,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1?.color,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            Container(
              width: 60,
              height: 60,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      controller.getMobileContacts();
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Icon(
                      Icons.refresh_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Obx(() {
          return controller.isLoading.value == true
              ? LoadingLayout()
              : ListView.builder(
                  itemCount: controller.contacts.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 16),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ContactListView(
                      callback: () {
                        Get.to(MessageScreen(),
                            arguments: [controller.contacts[index]]);
                      },
                      userModel: controller.contacts[index],
                    );
                  },
                );
        }));
  }
}

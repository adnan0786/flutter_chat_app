import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/profileController.dart';
import 'package:flutter_chat_app/screens/profileScreen.dart';
import 'package:get/get.dart';

class SettingScreen extends GetView<ProfileController> {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).backgroundColor,
        flexibleSpace: SafeArea(
          child: GestureDetector(
            onTap: () {
              Get.to(ProfileScreen());
            },
            child: Container(
              padding: EdgeInsets.only(right: 16, left: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Hero(
                            tag: "profileName",
                            child: Obx(
                              () => Text(
                                controller.userModel.value.name == ""
                                    ? "No Name"
                                    : controller.userModel.value.name,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            )),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "View & edit profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryColor,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Hero(
                      tag: "profileImage",
                      child: Obx(
                        () => controller.userModel.value.image == ""
                            ? CircleAvatar(
                                backgroundImage: AssetImage(
                                  "assets/images/default.png",
                                ),
                                maxRadius: 20,
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(
                                  controller.userModel.value.image,
                                ),
                                maxRadius: 20,
                              ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                tileColor: Theme.of(context).disabledColor.withOpacity(0.1),
                leading: Icon(
                  Icons.notifications_active,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Notification",
                ),
                trailing: Switch.adaptive(value: false, onChanged: (val) {}),
              ),
            ),
            ListTile(
              tileColor: Theme.of(context).disabledColor.withOpacity(0.1),
              leading: Icon(
                Icons.help,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "Help",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                tileColor: Theme.of(context).disabledColor.withOpacity(0.1),
                leading: Icon(
                  Icons.info,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "About",
                ),
              ),
            ),
            ListTile(
              tileColor: Theme.of(context).disabledColor.withOpacity(0.1),
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "Logout",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

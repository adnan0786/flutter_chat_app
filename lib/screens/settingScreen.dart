import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/appConstants.dart';
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
                          "View_&_edit_profile".tr,
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
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (){
                    controller.languagePickerDialog();
                  },
                  child: ListTile(
                    tileColor: Theme.of(context).disabledColor.withOpacity(0.1),
                    leading: Icon(
                      Icons.language_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      "Language".tr,
                    ),
                    trailing: Text(AppConstants.languageList[AppConstants
                        .languageCode
                        .indexOf(controller.selectedLanguage.value)]),
                  ),
                ),
              ),
            ),
            ListTile(
              tileColor: Theme.of(context).disabledColor.withOpacity(0.1),
              leading: Icon(
                Icons.help,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "Help".tr,
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
                  "About".tr,
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
                "Logout".tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

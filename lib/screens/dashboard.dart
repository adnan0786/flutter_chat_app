import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/dashboardController.dart';
import 'package:flutter_chat_app/screens/callScreen.dart';
import 'package:flutter_chat_app/screens/contactScreen.dart';
import 'package:flutter_chat_app/screens/chatListScreen.dart';
import 'package:flutter_chat_app/screens/settingScreen.dart';
import 'package:get/get.dart';

class Dashboard extends GetView<DashboardController> {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());
    return Scaffold(
        bottomNavigationBar: Obx(() => CurvedNavigationBar(
              key: controller.bottomNavigationKey,
              index: controller.page.value,
              color: Theme.of(context).primaryColor,
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              items: <Widget>[
                Icon(Icons.chat_rounded, size: 30, color: Colors.white),
                Icon(Icons.contacts_rounded, size: 30, color: Colors.white),
                Icon(Icons.phone_rounded, size: 30, color: Colors.white),
                Icon(Icons.settings_rounded, size: 30, color: Colors.white),
              ],
              onTap: (index) {
                controller.onItemClick(index);
                controller.pageController.jumpToPage(index);
              },
            )),
        backgroundColor: Theme.of(context).backgroundColor,
        body: PageView(
            physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            controller: controller.pageController,
            children: [
              ChatListScreen(),
              ContactScreen(),
              CallScreen(),
              SettingScreen(),
            ]));
  }
}

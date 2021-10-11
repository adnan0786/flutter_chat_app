import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
   late PageController pageController;
  GlobalKey bottomNavigationKey = GlobalKey();
  var page = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void onItemClick(int index) {
    if (index != page.value) page(index);
  }

  @override
  void onClose() {
    pageController.dispose();
  }
}

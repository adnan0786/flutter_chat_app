import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/IntroModel.dart';
import 'package:flutter_chat_app/screens/loginScreen.dart';
import 'package:flutter_chat_app/widgets/introView.dart';

// import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends StatelessWidget {
  IntroductionScreen({Key? key}) : super(key: key);
  PageController pageController = PageController(initialPage: 0);
  List<IntroModel> introPagesList = ([
    IntroModel(
      'Number Verification',
      '',
      'assets/images/intro1.jpg',
    ),
    IntroModel(
      'Find Friend Contact',
      '',
      'assets/images/intro2.jpg',
    ),
    IntroModel(
      'Online Messaging',
      '',
      'assets/images/intro3.jpg',
    ),
    IntroModel(
      'User Profile',
      '',
      'assets/images/intro4.jpg',
    ),
    IntroModel(
      'Settings',
      '',
      'assets/images/intro5.jpg',
    )
  ]);
  var currentShowIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                pageSnapping: true,
                physics: BouncingScrollPhysics(),
                onPageChanged: (index) {
                  currentShowIndex = index;
                },
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  IntroView(imageData: introPagesList[0]),
                  IntroView(imageData: introPagesList[1]),
                  IntroView(imageData: introPagesList[2]),
                  IntroView(imageData: introPagesList[3]),
                  IntroView(imageData: introPagesList[4]),
                ],
              ),
            ),
            SmoothPageIndicator(
                controller: pageController, count: introPagesList.length),
            Padding(
              padding: const EdgeInsets.only(
                  left: 48, right: 48, bottom: 32, top: 32),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context).disabledColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Get.to(LoginScreen());
                    },
                    child: Center(
                      child: Text(
                        "Register".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }
}

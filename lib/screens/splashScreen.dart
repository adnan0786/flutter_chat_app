import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/loginController.dart';
import 'package:flutter_chat_app/main.dart';
import 'package:flutter_chat_app/screens/introductionScreen.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController slideController;
  late Animation<Offset> _offsetAnimation;
  late Animation<Offset> textAnimation;

  @override
  void initState() {
    animationController = AnimationController(
        lowerBound: 0,
        upperBound: 60,
        vsync: this,
        animationBehavior: AnimationBehavior.normal,
        duration: Duration(seconds: 1));

    animationController..forward();

    slideController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.5, 0.0),
    ).animate(CurvedAnimation(
      parent: slideController,
      curve: Curves.fastOutSlowIn,
    ));
    textAnimation = Tween<Offset>(
      begin: Offset(-0.5, 0),
      end: const Offset(0.2, 0.0),
    ).animate(CurvedAnimation(
      parent: slideController,
      curve: Curves.fastOutSlowIn,
    ));

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        slideController..forward();
      }
    });

    Future.delayed(const Duration(seconds: 4), () {
      LoginController controller = Get.find<LoginController>();
      if (controller.auth.currentUser != null) {
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => IntroductionScreen()));
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                  animation: animationController,
                  builder: (_, child) {
                    return SlideTransition(
                      position: _offsetAnimation,
                      child: Icon(
                        Icons.chat,
                        color: Colors.white,
                        size: animationController.value,
                      ),
                    );
                  }),
              SlideTransition(
                position: textAnimation,
                child: Text(
                  "Flutter_Chat_App".tr,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

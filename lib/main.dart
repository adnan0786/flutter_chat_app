import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_app/appTheme.dart';
import 'package:flutter_chat_app/bindings/dashboardBinding.dart';
import 'package:flutter_chat_app/bindings/networkBinding.dart';
import 'package:flutter_chat_app/models/chatModel.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:flutter_chat_app/screens/dashboard.dart';
import 'package:flutter_chat_app/screens/messageScreen.dart';
import 'package:flutter_chat_app/screens/splashScreen.dart';
import 'package:flutter_chat_app/services/callService.dart';
import 'package:flutter_chat_app/utils/appLocalization.dart';
import 'package:flutter_chat_app/utils/localNotificationUtils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'models/notificationModel.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Get.putAsync(() => CallService().init());
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  firebaseMessaging.getToken().then((value) {
    if (value != null) if (FirebaseAuth.instance.currentUser != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      FirebaseService service = FirebaseService();
      service.updateToken(userId, value);
    }
  });

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  FirebaseMessaging.onMessage.listen((message) {
    NotificationModel notificationModel =
        NotificationModel.fromJson(message.data);
    LocalNotificationUtils.display(message);
  });

  ///When the app is in background but opened and user taps
  ///on the notification
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    NotificationModel notificationModel =
        NotificationModel.fromJson(message.data);
    print("object  onMessageOpenedApp");
    Get.to(MessageScreen(), arguments: [
      ChatModel(notificationModel.chatId, "", Timestamp.now(), List.empty(),
          image: notificationModel.image, name: notificationModel.name),
      notificationModel.userId
    ]);

    // Navigator.of(context).pushNamed(routeFromMessage);
  });

  ///gives you the message on which user taps
  ///and it opened the app from terminated state
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      print("object  getInitialMessage");
      NotificationModel notificationModel =
          NotificationModel.fromJson(message.data);
      Get.to(MessageScreen(), arguments: [
        ChatModel(notificationModel.chatId, "", Timestamp.now(), List.empty(),
            image: notificationModel.image, name: notificationModel.name),
        notificationModel.userId
      ]);

      // Navigator.of(context).pushNamed(routeFromMessage);
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocalNotificationUtils.initialize(context);
    return GetMaterialApp(
      title: 'Chat App',
      enableLog: true,
      translations: AppLocalization(),
      locale: Locale("en","US"),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: Routes.SPLASH_SCREEN, page: () => SplashScreen()),
        GetPage(
            name: Routes.DASHBOARD,
            page: () => Dashboard(),
            binding: DashboardBinding()),
      ],
      initialRoute: Routes.SPLASH_SCREEN,
      initialBinding: NetworkBinding(),
      themeMode: ThemeMode.system,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
    );
  }
}

class Routes {
  static const String SPLASH_SCREEN = "/";
  static const String DASHBOARD = "dashboard";
}

// When app is in background
Future<void> backgroundHandler(RemoteMessage message) async {
  print("object  backgroundHandler");
}

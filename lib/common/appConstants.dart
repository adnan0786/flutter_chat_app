import 'package:flutter/scheduler.dart';

class AppConstants {
  static String chatImagePath = "images/${DateTime.now()}";
  static String chatVideoPath = "videos/${DateTime.now()}";
  static String APP_ID = "04520808688f42e88041802bc0cbbd42";
  static List<String> supportedFiles = ["pdf", "txt", "docx"];
  static String textNotification = "100";
  static String imageNotification = "200";
  static String CHANNEL_NAME = "testing";
  static String serverKey =
      "AAAAL-xUY2c:APA91bHm_IIYq-l5vbIF6MuXiaamoSJJ-rELwezSA6IrwvQcyZjcn_YsJMQuxXNHylw3qEjaFrnzCjt-sLKXmw9WF41l8UDi5eTIdl0ASR_ntYw_II6ugMakpo9W4JkgjTuQaxYfgn1t";

  static String Token =
      "00604520808688f42e88041802bc0cbbd42IAAimafs0I7FXGR6h8iQm/mhgi/zqdSIe+CD7zXSr3fhHQZa8+gAAAAAEADKVPAlK6LWYQEAAQApotZh";

  static List languageList = [
    "Arabic",
    "English",
    "Spanish",
    "Urdu",
  ];

  static List languageCode = [
    "ar_SA",
    "en_US",
    "es_US",
    "ur_PK",
  ];
}

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_app/common/appConstants.dart';
import 'package:flutter_chat_app/models/callDetailModel.dart';
import 'package:flutter_chat_app/models/chatModel.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:flutter_chat_app/models/userModel.dart';
import 'package:flutter_chat_app/screens/verificationScreen.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  Future<void> sendVerificationCode(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) {
        printInfo(info: "user verified");
      },
      verificationFailed: (FirebaseAuthException e) {
        printError(info: e.toString());
        showErrorSnackBar(Get.context!, e.toString(), "Error", true);
      },
      codeSent: (String verificationId, int? resendToken) async {
        printInfo(info: "Code sent  successfully");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("code", verificationId);
        Get.to(VerificationScreen());
      },
      timeout: Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        printError(info: "Time Out");
      },
    );
  }

  Future<void> createUser(UserModel userModel) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection("users");
    await FirebaseAuth.instance.currentUser?.updateDisplayName(userModel.name);
    await FirebaseAuth.instance.currentUser?.updatePhotoURL(userModel.image);
    SharedPreferences.getInstance().then((value) {
      value.setString("number", userModel.number);
    });

    return await userCollection.doc(userModel.uId).set(userModel.toJson());
  }

  Future<String> uploadUserImage(String path, String uId, File file) async {
    Reference storage = FirebaseStorage.instance.ref(uId).child(path);
    UploadTask task = storage.putFile(file);
    TaskSnapshot snapshot = await task;
    String link = await snapshot.ref.getDownloadURL();
    print(link);

    return link;
  }

  Future<void> verifyOTP(String otp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? verificationId = prefs.getString("code");
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: otp);
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<String> updateName(String name) async {
    try {
      Map<String, Object> map = Map();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update(map);
      return name;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> updateStatus(String status) async {
    try {
      Map<String, dynamic> map = Map();
      map["status"] = status;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update(map);
      return status;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> updateImage(String imagePath) async {
    try {
      Map<String, dynamic> map = Map();
      map["image"] = imagePath;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update(map);
      return imagePath;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<UserModel>> getAppContacts() async {
    try {
      final data = await FirebaseFirestore.instance.collection("users").get();
      return data.docs.map((e) => UserModel.fromJson(e.data())).toList();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> isChatExist(String userId) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      CollectionReference chatRef =
          FirebaseFirestore.instance.collection("chatList");

      QuerySnapshot querySnapshot = await chatRef
          .where("members", arrayContainsAny: [auth.currentUser?.uid])
          .get(GetOptions(source: Source.serverAndCache))
          .then((value) =>
              chatRef.where("members", arrayContainsAny: [userId]).get());

      if (querySnapshot.size > 0 && querySnapshot.docs[0].exists) {
        return querySnapshot.docs[0].id;
      } else {
        return "";
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<UserModel> userUpdates(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromJson(event.data()!));
  }

  Future<String> createChat(String userId) async {
    try {
      final result = FirebaseFirestore.instance.collection("chatList").doc();

      ChatModel chatModel = ChatModel(result.id, "", Timestamp.now(),
          [userId, FirebaseAuth.instance.currentUser!.uid]);
      await result.set(chatModel.toJson());
      return result.id;
    } on Exception catch (e) {
      throw new Exception(e.toString());
    }
  }

  void sendTextMessage(String chatId, MessageModel messageModel) {
    try {
      Map<String, dynamic> map = Map();
      map["lastMessage"] = messageModel.message;
      map["lastDate"] = DateTime.now();
      final ref = FirebaseFirestore.instance.collection("chatList").doc(chatId);
      var messageDoc = ref.collection("messages").doc();
      messageModel.id = messageDoc.id;
      messageDoc.set(messageModel.toJson()).then((value) {
        ref.update(map);
      });
    } on Exception catch (e) {
      printError(info: e.toString());
    }
  }

  void sendPhotoMessage(
      String chatId, MessageModel messageModel, File image) async {
    try {
      String imagePath =
          await uploadUserImage(AppConstants.chatImagePath, chatId, image);
      messageModel.message = imagePath;
      var messageDoc = FirebaseFirestore.instance
          .collection("chatList")
          .doc(chatId)
          .collection("messages")
          .doc();
      messageModel.id = messageDoc.id;
      messageDoc.set(messageModel.toJson());
    } on Exception catch (e) {
      printError(info: e.toString());
    }
  }

  void sendAudioMessage(
      String chatId, MessageModel messageModel, File image) async {
    try {
      String path = "audio/${DateTime.now()}";
      String audioPath = await uploadUserImage(path, chatId, image);
      messageModel.message = audioPath;
      var messageDoc = FirebaseFirestore.instance
          .collection("chatList")
          .doc(chatId)
          .collection("messages")
          .doc();
      messageModel.id = messageDoc.id;
      messageDoc.set(messageModel.toJson());
    } on Exception catch (e) {
      printError(info: e.toString());
    }
  }

  void sendVideoMessage(
      String chatId, MessageModel messageModel, File video) async {
    try {
      String path = "video/${DateTime.now()}";
      String videoPath = await uploadUserImage(path, chatId, video);
      String thumbnailPath = await uploadUserImage(
          "thumbnail/${DateTime.now()}", chatId, File(messageModel.thumbnail));

      if (File(messageModel.thumbnail).existsSync())
        File(messageModel.thumbnail).deleteSync();
      messageModel.message = videoPath;
      messageModel.thumbnail = thumbnailPath;
      var messageDoc = FirebaseFirestore.instance
          .collection("chatList")
          .doc(chatId)
          .collection("messages")
          .doc();
      messageModel.id = messageDoc.id;
      messageDoc.set(messageModel.toJson());
    } on Exception catch (e) {
      printError(info: e.toString());
    }
  }

  Stream<List<ChatModel>> getChatList() {
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference chatRef =
        FirebaseFirestore.instance.collection("chatList");

    return chatRef
        .where("members", arrayContainsAny: [auth.currentUser?.uid])
        .orderBy('lastMessage', descending: true)
        .snapshots()
        .map((event) {
          return event.docs
              .map((e) => ChatModel.fromJson(e.data() as Map<String, dynamic>))
              .toList();
        });
  }

  Stream<UserModel> getUserInfo(String userId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromJson(event.data()!));
  }

  Stream<List<MessageModel>> getChatMessages(String chatId) {
    CollectionReference messageRef = FirebaseFirestore.instance
        .collection("chatList")
        .doc(chatId)
        .collection("messages");

    return messageRef.orderBy("date").snapshots().map((event) => event.docs
        .map((e) => MessageModel.fromJson(e.data() as Map<String, dynamic>))
        .toList());
  }

  void addStartMessage(String messageId, bool star, String chatId) {
    try {
      Map<String, dynamic> map = Map();
      map["star"] = star;
      FirebaseFirestore.instance
          .collection("chatList")
          .doc(chatId)
          .collection("messages")
          .doc(messageId)
          .update(map);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  void readMessage(String messageId, String chatId) {
    try {
      Map<String, dynamic> map = Map();
      map["read"] = true;
      FirebaseFirestore.instance
          .collection("chatList")
          .doc(chatId)
          .collection("messages")
          .doc(messageId)
          .update(map);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> callToUser(String userId, String type, String chatId) async {
    bool isTokenAvailable = await _isTokenAvailable();
    bool isUserAvailable = await _isUserAvailable(userId);
    String myId = FirebaseAuth.instance.currentUser!.uid;
    if (isTokenAvailable && isUserAvailable) {
      setTokenAvailability(false);
      setUserAvailability(false, userId, type, chatId);

      Timestamp time = Timestamp.now();
      addCallHistory(
          FirebaseAuth.instance.currentUser!.uid, userId, type, userId, time);

      addCallHistory(myId, userId, type, myId, time);
      return Future.value(true);
    } else {
      String msg = type == "audio" ? "Missed voice call" : "Missed video call";
      MessageModel messageModel = MessageModel(
          "id", myId, userId, msg, Timestamp.now(), "call", false, false, type);
      sendCallMessage(chatId, messageModel);
      Timestamp time = Timestamp.now();
      addCallHistory(
          FirebaseAuth.instance.currentUser!.uid, userId, type, userId, time);

      addCallHistory(myId, userId, type, myId, time);
      return Future.value(false);
    }
  }

  void setTokenAvailability(bool flag) {
    Map<String, dynamic> map = Map();
    map["token"] = flag;
    FirebaseFirestore.instance.collection("call").doc("token").set(map);
  }

  void setUserAvailability(
      bool flag, String userId, String type, String chatId) {
    Map<String, dynamic> map = Map();
    map["isAvailable"] = flag;
    map["type"] = type;
    map["chatId"] = chatId;
    FirebaseFirestore.instance.collection("call").doc(userId).set(map);
  }

  Future<bool> _isTokenAvailable() {
    return FirebaseFirestore.instance
        .collection("call")
        .doc("token")
        .get(GetOptions(source: Source.server))
        .then((value) {
      if (value.exists) {
        return value.data()!["token"];
      } else
        return true;
    });
  }

  Future<bool> _isUserAvailable(String userId) {
    return FirebaseFirestore.instance
        .collection("call")
        .doc(userId)
        .get(GetOptions(source: Source.server))
        .then((value) {
      if (value.exists) {
        return value.data()!["isAvailable"];
      } else
        return true;
    });
  }

  void addCallHistory(
      String from, String to, String type, String userId, Timestamp date) {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection("callHistory")
        .doc(userId)
        .collection("calls")
        .doc();

    CallDetailModel callDetailModel =
        CallDetailModel(docRef.id, type, from, to, false, date);

    docRef.set(callDetailModel.toJson());
  }

  void sendCallMessage(String chatId, MessageModel messageModel) {
    try {
      final ref = FirebaseFirestore.instance.collection("chatList").doc(chatId);
      var messageDoc = ref.collection("messages").doc();
      messageModel.id = messageDoc.id;
      messageDoc.set(messageModel.toJson());
    } on Exception catch (e) {
      printError(info: e.toString());
    }
  }

  Stream<Map<String, dynamic>> getCallInfo() {
    if (FirebaseAuth.instance.currentUser != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      return FirebaseFirestore.instance
          .collection("call")
          .doc(userId)
          .snapshots()
          .map((event) {
        if (event.exists) {
          return event.data()!;
        } else {
          return Map();
        }
      });
    } else {
      return Stream.empty();
    }
  }

  Stream<List<CallDetailModel>> getCallHistory() {
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference chatRef = FirebaseFirestore.instance
        .collection("callHistory")
        .doc(auth.currentUser!.uid)
        .collection("calls");
    return chatRef.orderBy("date").snapshots().map((event) => event.docs
        .map((e) => CallDetailModel.fromJson(e.data() as Map<String, dynamic>))
        .toList());
  }

  void updateToken(String userId, String token) {
    Map<String, dynamic> map = Map();
    map["token"] = token;
    FirebaseFirestore.instance.collection("users").doc(userId).update(map);
  }

  Future<void> sendPushMessage(String title, String body,
      Map<String, dynamic> data, String token) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=${AppConstants.serverKey}',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': data,
          'to': token,
        },
      ),
    );
  }
}

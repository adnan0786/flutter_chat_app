import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_app/common/appConstants.dart';
import 'package:flutter_chat_app/models/callDetailModel.dart';
import 'package:flutter_chat_app/models/chatModel.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:flutter_chat_app/models/status.dart';
import 'package:flutter_chat_app/models/statusModel.dart';
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
      String userId = FirebaseAuth.instance.currentUser!.uid;
      Map<String, Object> map = Map();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .update(map);

      FirebaseAuth.instance.currentUser!.updateDisplayName(name);
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

      FirebaseAuth.instance.currentUser!.updatePhotoURL(imagePath);
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

  Future<String?> isChatExist(String userId) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      CollectionReference chatRef =
          FirebaseFirestore.instance.collection("chatList");

      // QuerySnapshot querySnapshot = await chatRef
      //     .where("members", arrayContainsAny: [auth.currentUser?.uid])
      //     .get(GetOptions(source: Source.serverAndCache))
      //     .then((value) =>
      //         chatRef.where("members", arrayContainsAny: [userId]).get());
      QuerySnapshot querySnapshot = await chatRef
          .where("members", arrayContainsAny: [auth.currentUser?.uid]).get(
              GetOptions(source: Source.serverAndCache));

      if (querySnapshot.size > 0) {
        for (var snap in querySnapshot.docs) {
          var chatModel =
              ChatModel.fromJson(snap.data() as Map<String, dynamic>);
          if ((chatModel.members[0].toString() == userId &&
                  chatModel.members[1].toString() == auth.currentUser?.uid) ||
              (chatModel.members[0].toString() == auth.currentUser?.uid &&
                  chatModel.members[1].toString() == userId)) {
            return snap.id;
          }
        }
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

  void sendLocationMessage(String chatId, MessageModel messageModel) {
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
      if (value.exists)
        return value.data()!["token"];
      else
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

  Future<String?> getToken(String userId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get()
        .then((value) {
      if (value.exists)
        return value.data()!["token"].toString();
      else
        return "";
    });
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
          'notification': <String, dynamic>{'body': title, 'title': body},
          'priority': 'high',
          'data': data,
          'to': token,
        },
      ),
    );
  }

  Stream<List<MessageModel>> getStarredMessages(String chatId) {
    CollectionReference messageRef = FirebaseFirestore.instance
        .collection("chatList")
        .doc(chatId)
        .collection("messages");

    return messageRef
        .orderBy("date")
        .where("star", isEqualTo: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => MessageModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<MessageModel>> getMediaVideoMessages(String chatId) {
    CollectionReference messageRef = FirebaseFirestore.instance
        .collection("chatList")
        .doc(chatId)
        .collection("messages");

    return messageRef
        .orderBy("date")
        .where("type", isEqualTo: "video")
        .snapshots()
        .map((event) => event.docs
            .map((e) => MessageModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<MessageModel>> getMediaImageMessages(String chatId) {
    CollectionReference messageRef = FirebaseFirestore.instance
        .collection("chatList")
        .doc(chatId)
        .collection("messages");

    return messageRef
        .orderBy("date")
        .where("type", isEqualTo: "image")
        .snapshots()
        .map((event) => event.docs
            .map((e) => MessageModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<MessageModel>> getMediaAudioMessages(String chatId) {
    CollectionReference messageRef = FirebaseFirestore.instance
        .collection("chatList")
        .doc(chatId)
        .collection("messages");

    return messageRef
        .orderBy("date")
        .where("type", isEqualTo: "audio")
        .snapshots()
        .map((event) => event.docs
            .map((e) => MessageModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<MessageModel>> getMediaFileMessages(String chatId) {
    CollectionReference messageRef = FirebaseFirestore.instance
        .collection("chatList")
        .doc(chatId)
        .collection("messages");

    return messageRef
        .orderBy("date")
        .where("type", whereIn: ["pdf", "docx", "txt"])
        .snapshots()
        .map((event) => event.docs
            .map((e) => MessageModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  void sendFileMessage(
      String chatId, MessageModel messageModel, File file) async {
    try {
      String path = "file/${DateTime.now()}";
      String filePath = await uploadUserImage(path, chatId, file);

      if (File(messageModel.thumbnail).existsSync())
        File(messageModel.thumbnail).deleteSync();
      messageModel.message = filePath;
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

  void deleteChatMessage(MessageModel messageModel, String chatId) async {
    switch (messageModel.type) {
      case "text":
      case "location":
      case "call":
        FirebaseFirestore.instance
            .collection("chatList")
            .doc(chatId)
            .collection("messages")
            .doc(messageModel.id)
            .delete();
        break;

      case "image":
      case "video":
      case "audio":
      case "pdf":
      case "txt":
      case "pdf":
      case "docx":
        await FirebaseStorage.instance
            .refFromURL(messageModel.message)
            .delete();
        FirebaseFirestore.instance
            .collection("chatList")
            .doc(chatId)
            .collection("messages")
            .doc(messageModel.id)
            .delete();
        break;
    }
  }

  Stream<List<Status>> getMyStatus(String myId) {
    CollectionReference messageRef = FirebaseFirestore.instance
        .collection("status")
        .doc(myId)
        .collection("stories");

    return messageRef.orderBy("date").snapshots().map((event) => event.docs
        .map((e) => Status.fromJson(e.data() as Map<String, dynamic>))
        .toList());
  }

  void addNewStatus(Status status, String userId, String name, String image) {
    DocumentReference reference =
        FirebaseFirestore.instance.collection("status").doc(userId);
    StatusModel statusModel = StatusModel(Timestamp.now(), userId, name, image);
    reference.set(statusModel.toJson());
    String statusId = reference.collection("stories").doc().id;
    status.id = statusId;
    reference.collection("stories").doc(statusId).set(status.toJson());
  }

  Stream<List<StatusModel>> getAllStatus() {
    CollectionReference messageRef =
        FirebaseFirestore.instance.collection("status");
    return messageRef.orderBy("lastUpdate").snapshots().map((event) => event
        .docs
        .map((e) => StatusModel.fromJson(e.data() as Map<String, dynamic>))
        .toList());
  }

  Future<List<Status>> getStories(String id) async {
    printInfo(info: id);
    var stories = await FirebaseFirestore.instance
        .collection("status")
        .doc(id.trim())
        .collection("stories")
        .get();

    return stories.docs.map((e) => Status.fromJson(e.data())).toList();
  }

  void seenStatus(List<dynamic> members, String userId, String statusId) {
    Map<String, dynamic> map = Map();
    map["members"] = members;
    FirebaseFirestore.instance
        .collection("status")
        .doc(userId)
        .collection("stories")
        .doc(statusId)
        .set(map);
  }

  Future<UserModel> getStatusMemberDetail(String userId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get()
        .then((value) => UserModel.fromJson(value.data()!));
  }
}

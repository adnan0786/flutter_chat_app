import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/common/appPermissions.dart';
import 'package:flutter_chat_app/models/userModel.dart';
import 'package:flutter_chat_app/network/firebaseService.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactController extends GetxController {
  late AppPermissions appPermission;
  var isLoading = false.obs;
  var contacts = RxList<UserModel>();
  FirebaseService service = FirebaseService();
  late String userNumber = "";
  String myNumber = FirebaseAuth.instance.currentUser!.phoneNumber!;

  @override
  void onInit() async {
    super.onInit();
    appPermission = AppPermissions();
    SharedPreferences.getInstance().then((value) {
      userNumber = value.getString("number")!;
    });
    userNumber = "";
    await getMobileContacts();
  }

  Future<void> getMobileContacts() async {
    var result = await Permission.contacts.status;

    switch (result) {
      case PermissionStatus.denied:
        var status = await Permission.contacts.request().isGranted;
        status
            ? await getContacts()
            : showErrorSnackBar(Get.context!, "Contact Permission Denied",
                "Permission Denied", true);

        break;
      case PermissionStatus.granted:
        await getContacts();
        break;
      case PermissionStatus.restricted:
        showErrorSnackBar(Get.context!, "Your device not supported",
            " Contact Permission", true);
        break;
      case PermissionStatus.limited:
        showErrorSnackBar(Get.context!, "Application has limited access",
            "Limited Access", true);
        break;
      case PermissionStatus.permanentlyDenied:
        await openAppSettings();
        break;
    }
  }

  Future<void> getContacts() async {
    contacts.clear();
    isLoading(true);
    Iterable<Contact> result = await getMobileContact();
    if (result.length > 0) {
      List<UserModel> mobileContact = [];
      result.forEach((element) async {
        String number = element.phones!.elementAt(0).value!;
        number = number.replaceAll(RegExp('\\s'), "");
        if (number[0] == "0")
          number = number.replaceFirst(RegExp("(?:0)"), "+92");

        mobileContact.add(UserModel(
            uId: element.identifier!,
            name: element.displayName!,
            image: element.avatar.toString(),
            number: number,
            status: "",
            typing: "",
            online: ""));
      });
      List<UserModel> appContacts = await service.getAppContacts();
      appContacts.forEach((app) {
        for (var mobile in mobileContact) {
          if (app.number == mobile.number && app.number !=myNumber) {
            contacts.add(UserModel(
                uId: app.uId,
                name: mobile.name,
                image: app.image,
                number: app.number,
                status: app.status,
                typing: app.typing,
                online: app.online));
          }
        }
      });

      isLoading(false);
    } else
      isLoading(false);
  }
}

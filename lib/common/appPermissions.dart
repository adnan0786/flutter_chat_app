import 'package:permission_handler/permission_handler.dart';

class AppPermissions{

  Future<PermissionStatus> cameraPermission() {
    return Permission.camera.status;
  }

  Future<PermissionStatus> storagePermission() {
    return Permission.storage.status;
  }

  Future<PermissionStatus> micPermission() {
    return Permission.microphone.status;
  }

  Future<PermissionStatus> contactPermission() {
    return Permission.contacts.status;
  }

  Future<PermissionStatus> locationPermission() {
    return Permission.locationAlways.status;
  }
}



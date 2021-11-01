import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

Future<File> imgFromCamera(bool isCropped) async {
  File? result;
  final imagePicker = ImagePicker();
  final pickedFile = await imagePicker.getImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 85);
  if (pickedFile != null) {
    result = File(pickedFile.path);
    if (isCropped) result = await cropImage(result);
  }

  return result!;
}

Future<File> imgFromGallery(bool isCropped) async {
  late File result;
  final imagePicker = ImagePicker();
  final pickedFile =
      await imagePicker.getImage(source: ImageSource.gallery, imageQuality: 85);

  if (pickedFile != null) {
    result = File(pickedFile.path);
    if (isCropped) result = await cropImage(result);
  }
  return result;
}

Future<File> videoFromGallery() async {
  late File result;
  final imagePicker = ImagePicker();
  final pickedFile = await imagePicker.getVideo(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
      maxDuration: Duration(minutes: 2));

  if (pickedFile != null) result = File(pickedFile.path);

  return result;
}

Future<File> videoFromCamera() async {
  late File result;
  final imagePicker = ImagePicker();
  final pickedFile = await imagePicker.getVideo(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      maxDuration: Duration(minutes: 2));

  if (pickedFile != null) result = File(pickedFile.path);

  return result;
}

Future<File> cropImage(File imageFile) async {
  late File result;
  File? croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ));

  result = croppedFile!;

  return result;
}

void showErrorSnackBar(
    BuildContext context, String message, String title, bool isError) {
  Get.snackbar(
    title,
    message,
    titleText: Text(
      title,
      style: TextStyle(fontSize: 20, color: Colors.white),
    ),
    snackPosition: SnackPosition.BOTTOM,
    snackStyle: SnackStyle.FLOATING,
    messageText: Text(
      '$message',
      style: TextStyle(fontSize: 20, color: Colors.white),
    ),
    icon: Icon(
      Icons.error_outline,
      size: 32,
      color: Colors.white,
    ),
    backgroundColor: isError ? Colors.red : Colors.green,
    isDismissible: true,
    margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
    dismissDirection: SnackDismissDirection.HORIZONTAL,
    duration: Duration(seconds: 3),
    borderRadius: 20,
    boxShadows: [
      BoxShadow(
          color: Theme.of(context).shadowColor.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(4, 4))
    ],
  );
}

Future<Iterable<Contact>> getMobileContact() async {
  return await ContactsService.getContacts();
}

String timeAgo(DateTime dateTime, {bool numericDates = true}) {
  final date2 = DateTime.now();
  final difference = date2.difference(dateTime);

  if (difference.inDays > 8) {
    return dateTime.toString();
  } else if ((difference.inDays / 7).floor() >= 1) {
    return (numericDates) ? '1 week ago' : 'Last week';
  } else if (difference.inDays >= 2) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays >= 1) {
    return (numericDates) ? '1 day ago' : 'Yesterday';
  } else if (difference.inHours >= 2) {
    return '${difference.inHours} hours ago';
  } else if (difference.inHours >= 1) {
    return (numericDates) ? '1 hour ago' : 'An hour ago';
  } else if (difference.inMinutes >= 2) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inMinutes >= 1) {
    return (numericDates) ? '1 minute ago' : 'A minute ago';
  } else if (difference.inSeconds >= 3) {
    return '${difference.inSeconds} seconds ago';
  } else {
    return 'Just now';
  }
}

Future<bool> isDirectoryExist(String path)  {
  return  Directory(path).exists();
}

Future<Directory> createDirectory(String path) {
  return Directory(path).create();
}

Future<File?> generateThumbnail(File? file) async {
  return await VideoCompress.getFileThumbnail(file!.path,
      quality: 50, position: -1);
}

Future<MediaInfo?> getCompressedVideo(File file) async {
  return await VideoCompress.compressVideo(
    file.path,
    quality: VideoQuality.DefaultQuality,
    deleteOrigin: false, // It's false by default
  );
}

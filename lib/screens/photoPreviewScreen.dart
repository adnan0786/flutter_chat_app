import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoPreviewScreen extends StatelessWidget {
  final String userImage;

  const PhotoPreviewScreen({Key? key, required this.userImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: NetworkImage(userImage),
        filterQuality: FilterQuality.high,
        minScale: 0.10.toDouble(),
        maxScale: 1.toDouble(),
      ),
    );
  }
}

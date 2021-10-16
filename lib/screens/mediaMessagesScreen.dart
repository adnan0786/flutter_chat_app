import 'package:flutter/material.dart';

class MediaMessagesScreen extends StatelessWidget {
  const MediaMessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: AppBar().preferredSize.height,
              color: Colors.black,
              child: Row(children: [

              ],),
            ),
          ],
        ),
      ),
    );
  }
}

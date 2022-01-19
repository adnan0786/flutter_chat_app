import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/userModel.dart';
import 'package:flutter_chat_app/screens/mediaMessagesScreen.dart';
import 'package:flutter_chat_app/screens/starMessagesScreen.dart';
import 'package:get/get.dart';

class UserInfoScreen extends StatelessWidget {
  final UserModel userModel;

  const UserInfoScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 400.0,
            floating: true,
            pinned: false,
            snap: true,
            flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: FadeInImage.assetNetwork(
                    placeholder: "assets/images/default.png",
                    fit: BoxFit.fill,
                    image: userModel.image)),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).shadowColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(4, 4))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              userModel.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Icon(
                                      Icons.chat,
                                      color: Theme.of(context).primaryColor,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Icon(
                                      Icons.videocam_rounded,
                                      color: Theme.of(context).primaryColor,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Icon(
                                      Icons.call,
                                      color: Theme.of(context).primaryColor,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          userModel.number,
                          style: TextStyle(
                              color: Theme.of(context).disabledColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(userModel.status)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).shadowColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(4, 4))
                      ]),
                  child: Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.to(MediaMessagesScreen(),
                                arguments: [Get.arguments[0]]);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.blue.shade700.withOpacity(0.8),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  child: Center(
                                    child: Icon(
                                      Icons.photo_rounded,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Text(
                                  "Media_Links_&_Docs".tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                )),
                                Icon(
                                  Icons.navigate_next_rounded,
                                  color: Theme.of(context).disabledColor,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.to(StarMessagesScreen(), arguments: [
                              Get.arguments[0],
                              userModel.name,
                              userModel.image,
                            ]);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10, top: 10),
                            child: Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Color(0xffffdf00).withOpacity(0.8),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  child: Center(
                                    child: Icon(
                                      Icons.star_rounded,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Text(
                                  "Starred_Messages".tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                )),
                                Icon(
                                  Icons.navigate_next_rounded,
                                  color: Theme.of(context).disabledColor,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ])),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/userModel.dart';

class ContactListView extends StatelessWidget {
  final UserModel userModel;
  final VoidCallback callback;

  const ContactListView({
    Key? key,
    required this.userModel,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(),
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  userModel.image == ""
                      ? CircleAvatar(
                          backgroundImage: AssetImage("assets/images/default.png"),
                          maxRadius: 30,
                        )
                      : CircleAvatar(
                          backgroundImage:
                          NetworkImage(userModel.image),
                          maxRadius: 30,
                        ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            userModel.name == "No Name" ? "" : userModel.name,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            userModel.status,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

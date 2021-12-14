import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/messageController.dart';
import 'package:flutter_chat_app/models/locationModel.dart';
import 'package:flutter_chat_app/models/messageModel.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class LocationMessageView extends StatelessWidget {
  final MessageModel chatMessageModel;
  final String myId;
  final Function(LocationModel) onLocationClick;

  const LocationMessageView(
      {Key? key,
      required this.chatMessageModel,
      required this.myId,
      required this.onLocationClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!chatMessageModel.read && chatMessageModel.sender != myId)
      Get.find<MessageController>().readMessage(chatMessageModel.id);

    LocationModel locationModel =
        LocationModel.fromJson(jsonDecode(chatMessageModel.message));
    Set<Marker> markers = Set();
    markers.add(Marker(
        markerId: MarkerId("location"),
        position: LatLng(locationModel.lat, locationModel.lng)));
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
      child: Align(
        alignment: (chatMessageModel.sender != myId
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            radius: 8,
            onTap: () {
              onLocationClick(locationModel);
            },
            child: Container(
              width: 250,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Theme.of(context).disabledColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(4, 4))
              ]),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  AspectRatio(
                    aspectRatio: 1.1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AbsorbPointer(
                        absorbing: true,
                        child: GoogleMap(
                          zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target:
                                LatLng(locationModel.lat, locationModel.lng),
                            zoom: 15,
                          ),
                          markers: markers,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (chatMessageModel.star)
                          Icon(
                            Icons.star_rounded,
                            color: Color(0xffffdf00),
                            size: 15,
                          ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          DateFormat("HH:MM a")
                              .format(chatMessageModel.date.toDate()),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        chatMessageModel.read
                            ? Icon(Icons.done_all,
                                color: Color(0xffffdf00), size: 11)
                            : Icon(Icons.check,
                                color: (chatMessageModel.sender != myId
                                    ? Colors.black
                                    : Colors.white),
                                size: 10)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

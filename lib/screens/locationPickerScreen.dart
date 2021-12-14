import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/LocationPickerController.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends GetView<LocationPickerController> {
  const LocationPickerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LocationPickerController());
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            title: Text("Send Location",
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1?.color,
                    fontWeight: FontWeight.bold))),
        body: Obx(() => Stack(
              children: [
                GoogleMap(
                  mapType: controller.mapType.value,
                  initialCameraPosition: CameraPosition(
                    target: controller.currentLocation.value,
                    zoom: 14.4746,
                  ),
                  markers: controller.markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  trafficEnabled: controller.isTrafficEnable.value,
                  compassEnabled: false,
                  onMapCreated: (GoogleMapController controller) async {
                    this.controller.controller.complete(controller);
                    this.controller.mapController =
                        await this.controller.controller.future;
                    this.controller.getCurrentLocation();
                  },
                  onCameraMove: (cameraPosition) {
                    controller.markers.clear();
                  },
                  onCameraIdle: () {},
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            width: 30,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context).disabledColor,
                                      offset: Offset(4, 4),
                                      blurRadius: 5)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  controller.isTrafficEnable(
                                      !controller.isTrafficEnable.value);
                                },
                                borderRadius: BorderRadius.circular(5),
                                child: Center(
                                  child: Icon(
                                    Icons.traffic_rounded,
                                    color: controller.isTrafficEnable.value
                                        ? Colors.green.shade700
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: PopupMenuButton<MapType>(
                              initialValue: controller.mapType.value,
                              tooltip: "MapTypes",
                              onSelected: (mapType) {
                                controller.mapType.value = mapType;
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: controller.mapType.value ==
                                          MapType.normal
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Normal"),
                                            Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.green.shade700,
                                            )
                                          ],
                                        )
                                      : Text("Normal"),
                                  value: MapType.normal,
                                ),
                                PopupMenuItem(
                                  child: controller.mapType.value ==
                                          MapType.hybrid
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Hybrid"),
                                            Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.green.shade700,
                                            )
                                          ],
                                        )
                                      : Text("Hybrid"),
                                  value: MapType.hybrid,
                                ),
                                PopupMenuItem(
                                  child: controller.mapType.value ==
                                          MapType.satellite
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Satellite"),
                                            Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.green.shade700,
                                            )
                                          ],
                                        )
                                      : Text("Satellite"),
                                  value: MapType.satellite,
                                ),
                                PopupMenuItem(
                                  child: controller.mapType.value ==
                                          MapType.terrain
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Terrain"),
                                            Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.green.shade700,
                                            )
                                          ],
                                        )
                                      : Text("Terrain"),
                                  value: MapType.terrain,
                                )
                              ],
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Theme.of(context).disabledColor,
                                          offset: Offset(4, 4),
                                          blurRadius: 5)
                                    ],
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor),
                                child: Center(
                                  child: Icon(
                                    Icons.map_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: FloatingActionButton(
                              onPressed: () {
                                controller.getCurrentLocation();
                              },
                              child: Icon(
                                Icons.ten_k,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(4, 4))
                        ]),
                    child: Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: TextField(
                            controller: controller.searchController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search,
                            cursorColor: Theme.of(context).primaryColor,
                            maxLines: 1,
                            onSubmitted: (text) async {
                              await controller.searchLocation(text);
                            },
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                                errorMaxLines: 1,
                                contentPadding:
                                    EdgeInsets.only(top: 5, bottom: 5),
                                border: InputBorder.none,
                                hintText: "Search Place",
                                prefixIcon: Icon(Icons.search_rounded)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 25,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(4, 4))
                          ],
                          color: Theme.of(context).primaryColor),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            Get.back(
                                result: [controller.selectedLocation.value]);
                          },
                          child: Center(
                            child: Text(
                              "Done",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            )),
      ),
    );
  }
}

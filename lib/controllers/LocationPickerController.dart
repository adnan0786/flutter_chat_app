import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/utils/appUtils.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerController extends GetxController {
  RxSet<Marker> markers = RxSet<Marker>();
  Rx<MapType> mapType = Rx(MapType.hybrid);
  RxBool isTrafficEnable = RxBool(false);
  Rx<LatLng> currentLocation =
      Rx(LatLng(37.43296265331129, -122.08832357078792));
  Rx<LatLng> selectedLocation =
      Rx(LatLng(37.43296265331129, -122.08832357078792));
  Completer<GoogleMapController> controller = Completer();
  GoogleMapController? mapController;
  RxList<Location> searchLocations = RxList.empty();
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    mapController?.dispose();
    searchController.dispose();
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    currentLocation.value = LatLng(position.latitude, position.longitude);
    selectedLocation.value = LatLng(position.latitude, position.longitude);
    mapController
        ?.animateCamera(CameraUpdate.newLatLngZoom(currentLocation.value, 17));
    markers.clear();
    List<Placemark> locationDetail =
        await getAddressFromLocation(currentLocation.value);

    searchController.text = locationDetail[0].locality!;
    markers.add(Marker(
        markerId: MarkerId("currentLocation"),
        position: currentLocation.value,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
            title: locationDetail[0].name,
            snippet: locationDetail[0].locality)));
  }

  Future<List<Placemark>> getAddressFromLocation(LatLng latLng) async {
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    return placeMarks;
  }

  Future<List<Location>> getLocationFromAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    return locations;
  }

  Future<void> searchLocation(String address) async {
    searchLocations.clear();
    searchLocations.value = await getLocationFromAddress(address);
    if (searchLocations.length > 0) {
      markers.clear();

      var data = await getAddressFromLocation(
          LatLng(searchLocations[0].latitude, searchLocations[0].longitude));
      searchController.text = data[0].locality!;
      selectedLocation(
          LatLng(searchLocations[0].latitude, searchLocations[0].longitude));
      markers.add(Marker(
          markerId: MarkerId("value"),
          position:
              LatLng(searchLocations[0].latitude, searchLocations[0].longitude),
          infoWindow:
              InfoWindow(title: data[0].name, snippet: data[0].locality)));

      mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(markers.first.position, 17));
    } else
      showErrorSnackBar(Get.context!, "No location found", "Location", true);
  }
}

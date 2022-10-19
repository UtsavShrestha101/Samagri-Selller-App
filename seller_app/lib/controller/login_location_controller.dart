import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginLocationController extends GetxController {
  var location = TextEditingController().obs;
  var lat = 0.0.obs;
  var long = 0.0.obs;

  void initialize() {
    location.value.clear();
    lat.value = 0.0;
    long.value = 0.0;
  }

  void changeLocation(String value, double latitude, double longitude) {
    location.value.text = value;
    lat.value = latitude;
    long.value = longitude;
  }
}

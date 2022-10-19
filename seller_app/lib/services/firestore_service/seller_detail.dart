import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:myapp/controller/login_controller.dart';
import 'package:myapp/db/db_helper.dart';
import 'package:myapp/models/user_model.dart';
import 'package:flutter/material.dart';
import '../../widget/our_flutter_toast.dart';
import '../add_latitude_longitude/add_latitude_longitude.dart';

class SellerFireStore {
  addSeller(UserModel userModel, String url, BuildContext context) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance
          .collection("Sellers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "email": userModel.email,
        "name": userModel.name,
        "AddedOn": DateFormat('yyy-MM-dd').format(
          DateTime.now(),
        ),
        "password": userModel.password,
        "imageUrl": url,
        "phone": userModel.phone,
        "location": userModel.location,
        "lat": userModel.lat,
        "long": userModel.long,
        "token": token,
      });
      AddLatLongFirebase().addLatLong(userModel, url);
      await Hive.box<int>(DatabaseHelper.outerlayerDB).put("state", 2);
      Navigator.pop(context);

      Get.find<LoginController>().toggle(false);
    } catch (e) {
      print(e);
      OurToast().showErrorToast(e.toString());
      Get.find<LoginController>().toggle(false);
    }
  }
}

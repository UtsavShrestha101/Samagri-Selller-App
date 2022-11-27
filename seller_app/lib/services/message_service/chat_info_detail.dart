import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/seller_model.dart';
import 'package:myapp/models/user_model.dart';

import '../../models/user_model_firebase.dart';
import '../notification_service/notification_service.dart';

class ChatDetailFirebase {
  messageDetail(String message, FirebaseUser11Model userModel,
      FirebaseSellerModel sellerModel) async {
    print("MESSAGE DETAIL SCREEN");
    print("MESSAGE DETAIL SCREEN");
    print("MESSAGE DETAIL SCREEN");
    try {
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Chat")
          .doc(userModel.uid)
          .set({"timestamp": Timestamp.now(), "uid": userModel.uid});
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Chat")
          .doc(userModel.uid)
          .collection("Messages")
          .add({
        "message": message,
        "type": "text",
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "receiverId": userModel.uid,
        "imageUrl": "",
        "timestamp": Timestamp.now(),
      });
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(userModel.uid)
          .collection("Chat")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "timestamp": Timestamp.now(),
        "uid": FirebaseAuth.instance.currentUser!.uid,
      });
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(userModel.uid)
          .collection("Chat")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Messages")
          .add({
        "message": message,
        "type": "text",
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "receiverId": userModel.uid,
        "imageUrl": "",
        "timestamp": Timestamp.now(),
      });
      await NotificationService().sendNotification(
          "${sellerModel.name} messaged you",
          message,
          "userModel.profile_pic",
          "",
          userModel.token);
      print("Doneee sending message");
      print("Doneee sending message");
    } catch (e) {}
  }

  imageDetail(String downloadUrl, FirebaseUser11Model userModel,
      FirebaseSellerModel sellerModel) async {
    try {
      print("IMAGE DETAIL");
      print(downloadUrl);
      print("IMAGE DETAIL");

      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Chat")
          .doc(userModel.uid)
          .set({"timestamp": Timestamp.now(), "uid": userModel.uid});

      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Chat")
          .doc(userModel.uid)
          .collection("Messages")
          .add({
        "message": downloadUrl,
        "type": "image",
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "receiverId": userModel.uid,
        "imageUrl": "",
        "timestamp": Timestamp.now(),
      });
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(userModel.uid)
          .collection("Chat")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "timestamp": Timestamp.now(),
        "uid": FirebaseAuth.instance.currentUser!.uid,
      });
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(userModel.uid)
          .collection("Chat")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Messages")
          .add({
        "message": downloadUrl,
        "type": "image",
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "receiverId": userModel.uid,
        "imageUrl": "",
        "timestamp": Timestamp.now(),
      });
      await NotificationService().sendNotification(
          "${sellerModel.name} messaged you",
          "",
          "userModel.profile_pic",
          downloadUrl,
          userModel.token);
      print("Doneee sending message");
    } catch (e) {
      print("object");
    }
  }
}

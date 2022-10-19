import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:myapp/screens/authentication_screens/shopping_verify_otp_sigup_screen.dart';
import 'package:myapp/services/firestore_service/seller_detail.dart';
import 'package:myapp/widget/our_flutter_toast.dart';
import 'package:page_transition/page_transition.dart';
import '../../controller/dashboard_controller.dart';
import '../../controller/login_controller.dart';
import '../../controller/login_controller.dart';
import '../../db/db_helper.dart';
import '../../models/user_model.dart';
import '../../screens/authentication_screens/shopping_verify_otp_login_screen.dart';
import '../addImages/profile_image..dart';
import '../firestore_service/userprofile_detail.dart';

class PhoneAuth {
  sendLoginOTP(String phoneNo, BuildContext context) async {
    print("Inside send login OTP");
    FirebaseAuth auth = FirebaseAuth.instance;
    Get.find<LoginController>().toggle(true);
    try {
      Get.find<LoginController>().toggle(true);

      await auth.verifyPhoneNumber(
        phoneNumber: "+977$phoneNo",
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          print("++++++++++++++++");
          print(e.message);
          Get.find<LoginController>().toggle(false);

          print("++++++++++++++++");
          OurToast().showErrorToast(e.message!);
        },
        codeSent: (String verificationId, int? resendToken) {
          Get.find<LoginController>().setVerId(verificationId);
          OurToast().showSuccessToast("OTP sent");
          Get.find<LoginController>().toggle(false);

          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.leftToRight,
              child: VerifyOPTLoginScreen(
                phoneNumber: phoneNo,
              ),
            ),
          );
          // Get.find<LoginController>().toggle(false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 120),
      );
      // Get.find<LoginController>().toggle(false);
    } on FirebaseAuthException catch (e) {
      print("===============");
      print(e.message);
      print("===============");
      OurToast().showErrorToast(e.message!);
      Get.find<LoginController>().toggle(false);
      return false;
    }
  }

  vertfyLoginPin(String pin, BuildContext context) async {
    Get.find<LoginController>().toggle(true);

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: Get.find<LoginController>().verId.value,
      smsCode: pin,
    );
    try {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
        // Get.back();
        await UserDetailFirestore().uploadDetailLogin(context);
        // OurToast().showSuccessToast("User authenticated successfully");
        Get.find<LoginController>().toggle(false);
      });
      // Navigator.canPop(context);

      // OurToast().showSuccessToast("Login Successful");
      // Get.find<LoginController>().toggle(false);
    } on FirebaseAuthException catch (e) {
      Get.find<LoginController>().toggle(false);

      // print(e.message);
      OurToast().showErrorToast(e.message!);
    }
  }

  sendSignUpOTP(String phoneNo, String username, BuildContext context) async {
    print("Inside send signup OTP");
    FirebaseAuth auth = FirebaseAuth.instance;
    Get.find<LoginController>().toggle(true);
    try {
      Get.find<LoginController>().toggle(true);

      await auth.verifyPhoneNumber(
        phoneNumber: "+977$phoneNo",
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          print("++++++++++++++++");
          print(e.message);
          print("++++++++++++++++");
          Get.find<LoginController>().toggle(false);

          OurToast().showErrorToast(e.message!);
        },
        codeSent: (String verificationId, int? resendToken) {
          Get.find<LoginController>().setVerId(verificationId);
          OurToast().showSuccessToast("OTP sent");
          Get.find<LoginController>().toggle(false);

          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.leftToRight,
              child: VerifyOPTSignUpScreen(
                phoneNumber: phoneNo,
                username: username,
              ),
            ),
          );
          // Get.find<LoginController>().toggle(false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 120),
      );
    } on FirebaseAuthException catch (e) {
      print("===============");
      print(e.message);
      print("===============");
      OurToast().showErrorToast(e.message!);
      Get.find<LoginController>().toggle(false);
      return false;
    }
  }

  vertfySignUpPin(
      String pin, String username, String phoneNo, BuildContext context) async {
    Get.find<LoginController>().toggle(true);

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: Get.find<LoginController>().verId.value,
      smsCode: pin,
    );
    try {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
        // Get.back();
        await UserDetailFirestore()
            .uploadDetailSignUp(username, phoneNo, context);
        // OurToast().showSuccessToast("User authenticated successfully");
        Get.find<LoginController>().toggle(false);
      });
      // Navigator.canPop(context);

      // OurToast().showSuccessToast("Login Successful");
      // Get.find<LoginController>().toggle(false);
    } on FirebaseAuthException catch (e) {
      print("=========");
      print(e.message);
      print("=========");

      Get.find<LoginController>().toggle(false);

      // print(e.message);
      OurToast().showErrorToast(e.message!);
    }
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    Get.find<DashboardController>().changeIndexs(0);
    await Hive.box<int>(DatabaseHelper.outerlayerDB).put("state", 1);
  }
}

class Auth {
  createAccount(UserModel userModel, File file, BuildContext context) async {
    Get.find<LoginController>().toggle(true);
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      )
          .then((value) async {
        String? url = await AddProfile().uploadImage(file);
        //
        SellerFireStore().addSeller(
          userModel,
          url!,
          context,
        );
        OurToast().showSuccessToast("User signed successfully");
      });
    } on FirebaseAuthException catch (e) {
      Get.find<LoginController>().toggle(false);

      OurToast().showErrorToast(e.message!);
    }
  }
   loginAccount(String email, String password) async {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          Get.find<LoginController>().toggle(false);

          OurToast().showSuccessToast("User logged in successfully");
          // Get.off(
          //   const DashBoardScreen(),
          // );

          await Hive.box<int>(DatabaseHelper.outerlayerDB).put("state", 2);
        });
      } on FirebaseAuthException catch (e) {
        Get.find<LoginController>().toggle(false);

        OurToast().showErrorToast(e.message!);
      }
    }

  logout() async {
    try {
      FirebaseFirestore.instance
          .collection("Sellers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "token": "",
      });
      await FirebaseAuth.instance.signOut().then((value) async {
        Get.find<DashboardController>().changeIndexs(0);
        await Hive.box<int>(DatabaseHelper.outerlayerDB).put("state", 1);
      });
    } on FirebaseAuthException catch (e) {
      Get.find<LoginController>().toggle(false);

      OurToast().showErrorToast(e.message!);
    }

   

    // logout() async {
    //   try {
    //     await FirebaseAuth.instance.signOut().then((value) {
    //       OurToast().showSuccessToast("User logged out successfully");
    //       Hive.box<int>(authenticationDB).put("state", 0);
    //       Get.off(
    //         const LoginScreen(),
    //       );
    //       Get.find<AuthenticationController>().toggle(false);
    //     });
    //   } on FirebaseAuthException catch (e) {
    //     Get.find<AuthenticationController>().toggle(false);

    //     OurToast().showErrorToast(e.message!);
    //   }
    // }
  }
}

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/controller/login_controller.dart';
import 'package:myapp/controller/login_location_controller.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/screens/authentication_screens/shopping_verify_otp_sigup_screen.dart';
import 'package:myapp/services/phone_auth/phone_auth.dart';
import 'package:myapp/widget/our_elevated_button.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:page_transition/page_transition.dart';

import '../../services/current_location/get_current_location.dart';
import '../../utils/color.dart';
import '../../widget/our_flutter_toast.dart';
import '../../widget/our_spinner.dart';
import '../dashboard_screen/shopping_map_screen.dart';
import 'shopping_login_screen.dart';

class ShoppingRegisterScreen extends StatefulWidget {
  @override
  _ShoppingRegisterScreenState createState() => _ShoppingRegisterScreenState();
}

class _ShoppingRegisterScreenState extends State<ShoppingRegisterScreen> {
  TextEditingController _user_name_controller = TextEditingController();
  TextEditingController _phone_number_controller = TextEditingController();
  TextEditingController _email_controller = TextEditingController();
  TextEditingController _password_controller = TextEditingController();
  TextEditingController _location_controller = TextEditingController();
  FocusNode _email_node = FocusNode();
  FocusNode _password_node = FocusNode();
  FocusNode _user_name_node = FocusNode();
  FocusNode _phone_number_node = FocusNode();
  String imagePath = "";

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      imagePath = res!;
    });
  }

  Future<String?> pickImages() async {
    String? images;
    try {
      var files = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (files != null && files.files.isNotEmpty) {
        // for (var i = 0; i < files.files.length; i++) {
        //   images = File(files.files[i].path!);
        // }
        images = files.files[0].path!;
      } else {}
    } catch (e) {
      print(e);
      print("Error occured");
    }
    return images;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _user_name_controller.dispose();
    _phone_number_controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<LoginLocationController>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ModalProgressHUD(
          inAsyncCall: Get.find<LoginController>().processing.value,
          progressIndicator: OurSpinner(),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
                body: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(10),
                  vertical: ScreenUtil().setSp(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.1,
                      // ),
                      // Image.asset(
                      //   "assets/images/logo.png",
                      //   fit: BoxFit.contain,
                      //   height: ScreenUtil().setSp(200),
                      //   width: ScreenUtil().setSp(200),
                      // ),
                      // OurSizedBox(),
                      Text(
                        "Create an Account",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(27.5),
                          color: darklogoColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      OurSizedBox(),

                      imagePath == ""
                          ? GestureDetector(
                              onTap: () {
                                selectImages();
                              },
                              child: DottedBorder(
                                color: logoColor,
                                borderType: BorderType.RRect,
                                radius: Radius.circular(
                                  ScreenUtil().setSp(15),
                                ),
                                dashPattern: [10, 4],
                                strokeCap: StrokeCap.round,
                                child: Container(
                                  padding: EdgeInsets.all(
                                    ScreenUtil().setSp(20),
                                  ),
                                  width: double.infinity,
                                  height: ScreenUtil().setSp(140),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      ScreenUtil().setSp(15),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: ScreenUtil().setSp(35),
                                        color: logoColor,
                                      ),
                                      OurSizedBox(),
                                      Text(
                                        "Select Profile Images",
                                        style: TextStyle(
                                          color: logoColor,
                                          fontSize: ScreenUtil().setSp(
                                            17.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                selectImages();
                              },
                              child: Image.file(
                                File(imagePath),
                                fit: BoxFit.contain,
                                height: ScreenUtil().setSp(200),
                              ),
                            ),
                      OurSizedBox(),
                      OurSizedBox(),
                      Container(
                        margin: EdgeInsets.only(
                          left: ScreenUtil().setSp(22.5),
                          right: ScreenUtil().setSp(22.5),
                          // top: ScreenUtil().setSp(30),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(
                            ScreenUtil().setSp(15),
                          ),
                        ),
                        child: FxContainer.none(
                          borderRadiusAll: 4,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                focusNode: _email_node,
                                onEditingComplete: () {
                                  FocusScope.of(context)
                                      .requestFocus(_password_node);
                                },
                                controller: _email_controller,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(15),
                                  color: logoColor,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Colors.white70,
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: logoColor,
                                    fontSize: ScreenUtil().setSp(
                                      17.5,
                                    ),
                                  ),
                                  hintText: "Email",
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(16),
                                ),
                                autofocus: false,
                                keyboardType: TextInputType.emailAddress,
                                // textCapitalization:
                                //     TextCapitalization.sentences,
                              ),
                              Divider(
                                height: ScreenUtil().setSp(5),
                              ),
                              TextFormField(
                                focusNode: _password_node,
                                onEditingComplete: () {
                                  FocusScope.of(context)
                                      .requestFocus(_user_name_node);
                                },
                                controller: _password_controller,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(15),
                                  color: logoColor,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Colors.white70,
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: logoColor,
                                    fontSize: ScreenUtil().setSp(
                                      17.5,
                                    ),
                                  ),
                                  hintText: "Password",
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(16),
                                ),
                                obscureText: true,
                                autofocus: false,
                                keyboardType: TextInputType.text,
                                // textCapitalization:
                                //     TextCapitalization.sentences,
                              ),
                              Divider(
                                height: ScreenUtil().setSp(5),
                              ),
                              TextFormField(
                                focusNode: _user_name_node,
                                onEditingComplete: () {
                                  FocusScope.of(context)
                                      .requestFocus(_phone_number_node);
                                },
                                controller: _user_name_controller,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(15),
                                  color: logoColor,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Colors.white70,
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: logoColor,
                                    fontSize: ScreenUtil().setSp(
                                      17.5,
                                    ),
                                  ),
                                  hintText: "Username",
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(16),
                                ),
                                autofocus: false,
                                keyboardType: TextInputType.name,
                                // textCapitalization:
                                //     TextCapitalization.sentences,
                              ),
                              Divider(
                                height: ScreenUtil().setSp(5),
                              ),
                              TextFormField(
                                focusNode: _phone_number_node,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                controller: _phone_number_controller,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(15),
                                  color: logoColor,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Colors.white70,
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: logoColor,
                                    fontSize: ScreenUtil().setSp(
                                      17.5,
                                    ),
                                  ),
                                  hintText: "Phone number",
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(16),
                                ),
                                autofocus: false,
                                keyboardType: TextInputType.phone,
                              ),
                              Divider(
                                height: ScreenUtil().setSp(5),
                              ),
                              Obx(
                                () => TextFormField(
                                  controller:
                                      Get.find<LoginLocationController>()
                                          .location
                                          .value,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                    color: logoColor,
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    Position? position;
                                    position = await GetCurrentLocation()
                                        .getCurrentLocation();

                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        child: ShopMapScreen(
                                          pinWidget: Icon(
                                            Icons.location_pin,
                                            color: Colors.red,
                                            size: ScreenUtil().setSp(50),
                                          ),
                                          pinColor: Colors.blue,
                                          addressPlaceHolder: "Loading",
                                          addressTitle: "Address",
                                          apiKey:
                                              "AIzaSyBlMkiLJ-G7YNmFabacXbMwfI2dectJSfs",
                                          appBarTitle:
                                              "Select Current location",
                                          confirmButtonColor: logoColor,
                                          confirmButtonText: "Done",
                                          confirmButtonTextColor: Colors.white,
                                          country: "NP",
                                          language: "en",
                                          searchHint: "Search",
                                          initialLocation: LatLng(
                                            position!.latitude,
                                            position.longitude,
                                          ),
                                        ),
                                        type: PageTransitionType.leftToRight,
                                      ),
                                    );
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.white70,
                                    filled: true,
                                    hintStyle: TextStyle(
                                      color: logoColor,
                                      fontSize: ScreenUtil().setSp(
                                        17.5,
                                      ),
                                    ),
                                    hintText: "Location",
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(16),
                                  ),
                                  autofocus: false,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      OurSizedBox(),
                      Container(
                        height: ScreenUtil().setSp(40),
                        margin: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setSp(22.5),
                        ),
                        width: double.infinity,
                        child: OurElevatedButton(
                          title: "Continue",
                          function: () async {
                            if (_user_name_controller.text.trim().isEmpty ||
                                _phone_number_controller.text.trim().isEmpty ||
                                _email_controller.text.trim().isEmpty ||
                                _password_controller.text.trim().isEmpty ||
                                Get.find<LoginLocationController>()
                                    .location
                                    .value
                                    .text
                                    .trim()
                                    .isEmpty) {
                              OurToast().showErrorToast("Field can't be empty");
                            } else {
                              // await PhoneAuth().sendSignUpOTP(
                              //     _phone_number_controller.text.trim(),
                              //     _user_name_controller.text.trim(),
                              //     context);
                              if (imagePath == "") {
                                OurToast().showErrorToast(
                                    "Please select profile image");
                              } else {
                                if (_email_controller.text
                                    .trim()
                                    .contains("@")) {
                                  if (_password_controller.text.trim().length >=
                                      6) {
                                    UserModel userModel = UserModel(
                                      imageUrl: "",
                                      lat: Get.find<LoginLocationController>()
                                          .lat
                                          .value,
                                      long: Get.find<LoginLocationController>()
                                          .long
                                          .value,
                                      name: _user_name_controller.text.trim(),
                                      email: _email_controller.text.trim(),
                                      password:
                                          _password_controller.text.trim(),
                                      phone:
                                          _phone_number_controller.text.trim(),
                                      location:
                                          Get.find<LoginLocationController>()
                                              .location
                                              .value
                                              .text
                                              .trim(),
                                    );
                                    Auth().createAccount(
                                      userModel,
                                      File(imagePath),
                                      context,
                                    );
                                    // OurToast().showErrorToast("Valid");
                                  } else {
                                    OurToast().showErrorToast(
                                        "Password must be atleast 6 character long");
                                  }
                                } else {
                                  OurToast()
                                      .showErrorToast("Email Badly formatted");
                                }
                              }
                            }
                          },
                        ),
                      ),
                      // Container(
                      //     margin: EdgeInsets.only(left: 24, right: 24, top: 36),
                      //     child: FxButton.block(
                      //       borderRadiusAll: 4,
                      //       padding: FxSpacing.y(12),
                      //       elevation: 0,
                      //       onPressed: () {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => ShoppingFullApp()));
                      //       },
                      //       child: FxText.b2("CONTINUE",
                      //           letterSpacing: 0.8, fontWeight: 700),
                      //     )),
                      OurSizedBox(),

                      Center(
                        child: FxButton.text(
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ShoppingLoginScreen()));
                          },
                          child: FxText.b2(
                            "I have an account",
                            decoration: TextDecoration.underline,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
            )),
          ),
        ));
  }
}

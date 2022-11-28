import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/controller/my_seller_cart_controller.dart';
import 'package:myapp/screens/dashboard_screen/shopping_address_choosing_screen.dart';
import 'package:myapp/screens/dashboard_screen/shopping_check_account_screen.dart';
import 'package:myapp/screens/dashboard_screen/test_screen.dart';
import 'package:myapp/services/pick_service/pick_service.dart';
import 'package:myapp/widget/our_cart_item_widget.dart';
import 'package:myapp/widget/our_elevated_button.dart';
import 'package:myapp/widget/our_shimeer_text.dart';
import 'package:myapp/widget/our_spinner.dart';
import 'package:page_transition/page_transition.dart';
import '../../controller/check_out_screen_controller.dart';
import '../../controller/login_controller.dart';
import '../../models/cart_product_model.dart';
import '../../models/firebase_user_model.dart';
import '../../models/my_order_request_product.dart';
import '../../utils/color.dart';
import '../../widget/our_sized_box.dart';

class ShoppingMyCartScreen extends StatefulWidget {
  const ShoppingMyCartScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingMyCartScreen> createState() => _ShoppingMyCartScreenState();
}

class _ShoppingMyCartScreenState extends State<ShoppingMyCartScreen>
    with TickerProviderStateMixin {
  Position? position;
  late AnimationController animationControllerListPage;
  late Animation<double> logoAnimationList;
  late Animation<double> fadeAnimation;
  late AnimationController animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<SellerCartController>().initialize();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animationControllerListPage = AnimationController(
      duration: Duration(milliseconds: 900),
      vsync: this,
    );

    logoAnimationList = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(
        parent: animationControllerListPage,
        curve: Curves.linear,
      ),
    );
    animationControllerListPage.repeat(reverse: true);
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
    );
    animationController.forward();
  }

  late FirebaseUserModel firebaseUserModel;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ModalProgressHUD(
        inAsyncCall: Get.find<LoginController>().processing.value,
        progressIndicator: OurSpinner(),
        child: Scaffold(
          body: FadeTransition(
            opacity: fadeAnimation,
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(10),
                  vertical: ScreenUtil().setSp(10),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RotationTransition(
                            turns: logoAnimationList,
                            child: Image.asset(
                              "assets/images/logo.png",
                              height: ScreenUtil().setSp(23.5),
                              width: ScreenUtil().setSp(23.5),
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setSp(7.5),
                          ),
                          Text(
                            "My Orders",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(25),
                              color: darklogoColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OurSizedBox(),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.find<SellerCartController>().changeIndex(0);
                            },
                            child: Container(
                              height: ScreenUtil().setSp(80),
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setSp(10),
                                vertical: ScreenUtil().setSp(5),
                              ),
                              decoration: BoxDecoration(
                                color: Get.find<SellerCartController>()
                                            .index
                                            .value ==
                                        0
                                    ? darklogoColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  ScreenUtil().setSp(17.5),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Pending\nOrders",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(17.5),
                                        color: Get.find<SellerCartController>()
                                                    .index
                                                    .value ==
                                                0
                                            ? Colors.white
                                            : darklogoColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.find<SellerCartController>().changeIndex(1);
                            },
                            child: Container(
                              height: ScreenUtil().setSp(80),
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setSp(10),
                                vertical: ScreenUtil().setSp(5),
                              ),
                              decoration: BoxDecoration(
                                color: Get.find<SellerCartController>()
                                            .index
                                            .value ==
                                        1
                                    ? darklogoColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  ScreenUtil().setSp(17.5),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Packed\nOrders",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(17.5),
                                        color: Get.find<SellerCartController>()
                                                    .index
                                                    .value ==
                                                1
                                            ? Colors.white
                                            : darklogoColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    OurSizedBox(),
                    Get.find<SellerCartController>().index.value == 0
                        ? Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("RequestOrder")
                                  .where("productOwnerId",
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .where("ispicked", isEqualTo: false)
                                  .orderBy(
                                    "requestedOn",
                                    descending: true,
                                  )
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: const OurSpinner(),
                                  );
                                } else if (snapshot.hasData) {
                                  if (snapshot.data!.docs.length > 0) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              MyOrderRequestProduct
                                                  myOrderRequestProduct =
                                                  MyOrderRequestProduct.fromMap(
                                                      snapshot
                                                          .data!.docs[index]);
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                  vertical:
                                                      ScreenUtil().setSp(5),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      ScreenUtil().setSp(5),
                                                  vertical:
                                                      ScreenUtil().setSp(5),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    ScreenUtil().setSp(10),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Text(myOrderRequestProduct
                                                    //     .productName),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            "Batch id:",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          17.5),
                                                              color:
                                                                  darklogoColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: ScreenUtil()
                                                              .setSp(5),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            myOrderRequestProduct
                                                                .batchId,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          15),
                                                              color:
                                                                  darklogoColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            textAlign: TextAlign
                                                                .justify,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    OurSizedBox(),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            "Product Name:",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          17.5),
                                                              color:
                                                                  darklogoColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: ScreenUtil()
                                                              .setSp(5),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            myOrderRequestProduct
                                                                .productName,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          15),
                                                              color:
                                                                  darklogoColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            textAlign: TextAlign
                                                                .justify,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    OurSizedBox(),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                        vertical: ScreenUtil()
                                                            .setSp(3.5),
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8)),
                                                            child:
                                                                // Image.network(
                                                                //   widget.cartProductModel.url[0],
                                                                //   height: ScreenUtil().setSp(90),
                                                                //   fit: BoxFit.fill,
                                                                // ),
                                                                CachedNetworkImage(
                                                              height:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          90),
                                                              fit: BoxFit.fill,
                                                              imageUrl:
                                                                  myOrderRequestProduct
                                                                      .productImage,
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Image
                                                                          .asset(
                                                                "assets/images/placeholder.png",
                                                                height:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            90),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: ScreenUtil()
                                                                .setSp(10),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Quantity:",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            15),
                                                                    color:
                                                                        darklogoColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                OurSizedBox(),
                                                                Text(
                                                                  myOrderRequestProduct
                                                                      .quantity
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            13.5),
                                                                    color:
                                                                        darklogoColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Product price:",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            15),
                                                                    color:
                                                                        darklogoColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                OurSizedBox(),
                                                                Text(
                                                                  myOrderRequestProduct
                                                                      .price
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            13.5),
                                                                    color:
                                                                        darklogoColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    myOrderRequestProduct
                                                                .ispicked ==
                                                            false
                                                        ? Center(
                                                            child:
                                                                OurElevatedButton(
                                                              title: "Pack",
                                                              function:
                                                                  () async {
                                                                await PickService()
                                                                    .addPickedService(
                                                                  myOrderRequestProduct,
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        : Text(
                                                            "Already Picked",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          17.5),
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/logo.png",
                                            fit: BoxFit.contain,
                                            height: ScreenUtil().setSp(150),
                                            width: ScreenUtil().setSp(150),
                                          ),
                                          OurSizedBox(),
                                          Text(
                                            "We're sorry",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: logoColor,
                                              fontSize:
                                                  ScreenUtil().setSp(17.5),
                                            ),
                                          ),
                                          OurSizedBox(),
                                          Text(
                                            "No item requested",
                                            style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: ScreenUtil().setSp(15),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/logo.png",
                                        fit: BoxFit.contain,
                                        height: ScreenUtil().setSp(150),
                                        width: ScreenUtil().setSp(150),
                                      ),
                                      OurSizedBox(),
                                      Text(
                                        "We're sorry",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: logoColor,
                                          fontSize: ScreenUtil().setSp(17.5),
                                        ),
                                      ),
                                      OurSizedBox(),
                                      Text(
                                        "No item requested",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: ScreenUtil().setSp(15),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("RequestOrder")
                                  .where("productOwnerId",
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .where("ispicked", isEqualTo: true)
                                  .orderBy(
                                    "requestedOn",
                                    descending: true,
                                  )
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: const OurSpinner(),
                                  );
                                } else if (snapshot.hasData) {
                                  if (snapshot.data!.docs.length > 0) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              MyOrderRequestProduct
                                                  myOrderRequestProduct =
                                                  MyOrderRequestProduct.fromMap(
                                                      snapshot
                                                          .data!.docs[index]);
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                  vertical:
                                                      ScreenUtil().setSp(5),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      ScreenUtil().setSp(5),
                                                  vertical:
                                                      ScreenUtil().setSp(5),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    ScreenUtil().setSp(10),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Text(myOrderRequestProduct
                                                    //     .productName),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            "Batch id:",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          17.5),
                                                              color:
                                                                  darklogoColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: ScreenUtil()
                                                              .setSp(5),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            myOrderRequestProduct
                                                                .batchId,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          15),
                                                              color:
                                                                  darklogoColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            textAlign: TextAlign
                                                                .justify,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    OurSizedBox(),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            "Product Name:",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          17.5),
                                                              color:
                                                                  darklogoColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: ScreenUtil()
                                                              .setSp(5),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            myOrderRequestProduct
                                                                .productName,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          15),
                                                              color:
                                                                  darklogoColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            textAlign: TextAlign
                                                                .justify,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    OurSizedBox(),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                        vertical: ScreenUtil()
                                                            .setSp(3.5),
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8)),
                                                            child:
                                                                // Image.network(
                                                                //   widget.cartProductModel.url[0],
                                                                //   height: ScreenUtil().setSp(90),
                                                                //   fit: BoxFit.fill,
                                                                // ),
                                                                CachedNetworkImage(
                                                              height:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          90),
                                                              fit: BoxFit.fill,
                                                              imageUrl:
                                                                  myOrderRequestProduct
                                                                      .productImage,
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Image
                                                                          .asset(
                                                                "assets/images/placeholder.png",
                                                                height:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            90),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: ScreenUtil()
                                                                .setSp(10),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Quantity:",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            15),
                                                                    color:
                                                                        darklogoColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                OurSizedBox(),
                                                                Text(
                                                                  myOrderRequestProduct
                                                                      .quantity
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            13.5),
                                                                    color:
                                                                        darklogoColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Product price:",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            15),
                                                                    color:
                                                                        darklogoColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                OurSizedBox(),
                                                                Text(
                                                                  myOrderRequestProduct
                                                                      .price
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            13.5),
                                                                    color:
                                                                        darklogoColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    myOrderRequestProduct
                                                                .ispicked ==
                                                            false
                                                        ? Center(
                                                            child:
                                                                OurElevatedButton(
                                                              title: "Pack",
                                                              function:
                                                                  () async {
                                                                await PickService()
                                                                    .addPickedService(
                                                                  myOrderRequestProduct,
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        : Align(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            child: Text(
                                                              "Already Picked",
                                                              style: TextStyle(
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                            17.5),
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/logo.png",
                                            fit: BoxFit.contain,
                                            height: ScreenUtil().setSp(150),
                                            width: ScreenUtil().setSp(150),
                                          ),
                                          OurSizedBox(),
                                          Text(
                                            "We're sorry",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: logoColor,
                                              fontSize:
                                                  ScreenUtil().setSp(17.5),
                                            ),
                                          ),
                                          OurSizedBox(),
                                          Text(
                                            "No item requested",
                                            style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: ScreenUtil().setSp(15),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/logo.png",
                                        fit: BoxFit.contain,
                                        height: ScreenUtil().setSp(150),
                                        width: ScreenUtil().setSp(150),
                                      ),
                                      OurSizedBox(),
                                      Text(
                                        "We're sorry",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: logoColor,
                                          fontSize: ScreenUtil().setSp(17.5),
                                        ),
                                      ),
                                      OurSizedBox(),
                                      Text(
                                        "No item requested",
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: ScreenUtil().setSp(15),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

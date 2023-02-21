import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/controller/quantity_controller.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/models/review_model.dart';
import 'package:myapp/screens/dashboard_screen/shopping_shop_profile_screen.dart';
import 'package:myapp/services/recommendation_history/recommendation_history.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_sized_box.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import '../../controller/login_controller.dart';
import '../../models/firebase_user_model.dart';
import '../../models/user_model.dart';
import '../../services/firestore_service/product_detail.dart';
import '../../services/firestore_service/userprofile_detail.dart';
import '../../widget/our_elevated_button.dart';
import '../../widget/our_flutter_toast.dart';
import '../../widget/our_recommendation_widget.dart';
import '../../widget/our_shimeer_text.dart';
import '../../widget/our_spinner.dart';
import '../../widget/our_text_field.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:like_button/like_button.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ShoppingProductScreen extends StatefulWidget {
  final String heroTag;
  final ProductModel productModel;
  const ShoppingProductScreen({
    Key? key,
    this.heroTag = "heroTag",
    required this.productModel,
    // this.image = './assets/images/apps/shopping/product/product-3.jpg'
  }) : super(key: key);

  @override
  _ShoppingProductScreenState createState() => _ShoppingProductScreenState();
}

class _ShoppingProductScreenState extends State<ShoppingProductScreen>
    with TickerProviderStateMixin {
  TextEditingController _review_Controller = TextEditingController();

//  with TickerProviderStateMixin {
  late AnimationController ButtomanimationController;
  late AnimationController ReverseButtomanimationController;
  late AnimationController animationControllerListPage;
  late Animation<double> logoAnimationList;
  late Animation<double> fadeAnimation;
  late AnimationController animationController;
  late AnimationController cartController;
  late Animation<double?> sizeAnimation, cartAnimation, paddingAnimation;
  late Animation<Color?> colorAnimation;
  late Animation<Color?> reversecolorAnimation;

  bool value = false;
  @override
  void dispose() {
    addrecommendationService();
    ReverseButtomanimationController.dispose();
    ButtomanimationController.dispose();
    animationController.dispose();
    animationControllerListPage.dispose();
    print("DISPOSING TIME");
    print("DISPOSED HAI ALREADY");
    super.dispose();
  }

  addrecommendationService() async {
    await RecommendationHistoryService()
        .recommendationServiceFirebase(widget.productModel);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animationControllerListPage = AnimationController(
      duration: Duration(milliseconds: 900),
      vsync: this,
    );
    ButtomanimationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );
    ReverseButtomanimationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
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
    Get.find<QuantityController>().changeQuantity(1);

    cartController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    colorAnimation = ColorTween(
      begin: Colors.grey.shade400,
      end: Colors.red,
    ).animate(ButtomanimationController);
    reversecolorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.grey.shade400,
    ).animate(ReverseButtomanimationController);

    sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(
              begin: ScreenUtil().setSp(25), end: ScreenUtil().setSp(35)),
          weight: 50),
      TweenSequenceItem<double>(
          tween: Tween<double>(
              begin: ScreenUtil().setSp(35), end: ScreenUtil().setSp(25)),
          weight: 50)
    ]).animate(ButtomanimationController);

    cartAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 24, end: 28), weight: 50),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 28, end: 24), weight: 50)
    ]).animate(cartController);

    paddingAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 16, end: 14), weight: 50),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 14, end: 16), weight: 50)
    ]).animate(cartController);
  }

  void GiveRatingSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xffe1ebfa),
            height: MediaQuery.of(context).size.height * 0.75,
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(20),
              vertical: ScreenUtil().setSp(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Reviews",
                  style: TextStyle(
                    color: darklogoColor,
                    fontSize: ScreenUtil().setSp(25),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(
                  color: darklogoColor,
                ),
                const OurSizedBox(),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("All")
                        .doc(widget.productModel.uid)
                        .collection("Reviews")
                        .orderBy(
                          "timestamp",
                          descending: true,
                        )
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.length > 0) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                ReviewModel reviewModel = ReviewModel.fromMap(
                                    snapshot.data!.docs[index]);
                                return InkWell(
                                  onLongPress: () async {
                                    if (reviewModel.senderId ==
                                        FirebaseAuth
                                            .instance.currentUser!.uid) {
                                      await FirebaseFirestore.instance
                                          .collection("All")
                                          .doc(widget.productModel.uid)
                                          .collection("Reviews")
                                          .doc(reviewModel.uid)
                                          .delete();
                                      OurToast()
                                          .showErrorToast("Review Deleted");
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  reviewModel.review,
                                                  style: TextStyle(
                                                    color: logoColor,
                                                    fontSize: ScreenUtil()
                                                        .setSp(17.5),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const OurSizedBox(),
                                                Text(
                                                  reviewModel.senderName,
                                                  style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(12.5),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              timeago.format(
                                                reviewModel.timestamp.toDate(),
                                              ),
                                              style: TextStyle(
                                                color: logoColor,
                                                fontSize:
                                                    ScreenUtil().setSp(13.5),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: darklogoColor,
                                      ),
                                    ],
                                  ),
                                );
                              });
                        } else {
                          return Center(
                            child: Text(
                              "No Reviews yet",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(20),
                                color: logoColor,
                              ),
                            ),
                          );
                        }
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: OurSpinner());
                      }
                      return const OurSpinner();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          letterlength: 10000,
                          icon: Icons.reviews,
                          controller: _review_Controller,
                          validator: (value) {},
                          title: "Give Review",
                          type: TextInputType.name,
                          number: 1,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (_review_Controller.text.trim().isNotEmpty) {
                            Get.find<LoginController>().toggle(true);
                            var data = await FirebaseFirestore.instance
                                .collection("Users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .get();

                            var name = data.data()!["name"];
                            await ProductDetailFirestore().addReview(
                              _review_Controller.text.trim(),
                              widget.productModel.uid,
                              name,
                            );
                            _review_Controller.clear();
                            FocusManager.instance.primaryFocus?.unfocus();
                            Get.find<LoginController>().toggle(false);
                          } else {
                            OurToast().showErrorToast("Review can't be empty");
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: logoColor,
                          size: ScreenUtil().setSp(30),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> _showMyDialog(double rate, bool exists) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  "Give Rating",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(24.5),
                      color: darklogoColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RatingStars(
                    onValueChanged: (value) {
                      setState(() {
                        rate = value;
                      });
                    },
                    value: rate,
                    starBuilder: (index, color) => Icon(
                      Icons.star,
                      color: color,
                      size: ScreenUtil().setSp(25),
                    ),
                    starCount: 5,
                    starSize: ScreenUtil().setSp(20),
                    valueLabelColor: const Color(0xff9b9b9b),
                    valueLabelTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                    valueLabelRadius: ScreenUtil().setSp(20),
                    maxValue: 5,
                    starSpacing: ScreenUtil().setSp(10),
                    maxValueVisibility: true,
                    valueLabelVisibility: true,
                    animationDuration: const Duration(milliseconds: 1000),
                    valueLabelPadding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setSp(5),
                      horizontal: ScreenUtil().setSp(5),
                    ),
                    valueLabelMargin: EdgeInsets.only(
                      right: ScreenUtil().setSp(3),
                    ),
                    starOffColor: const Color(0xffe7e8ea),
                    starColor: darklogoColor,
                  ),
                  OurSizedBox(),
                  InkWell(
                    onTap: () async {
                      await ProductDetailFirestore()
                          .addRating(widget.productModel, rate);
                      if (!exists) {
                        await ProductDetailFirestore()
                            .updateRatingNo(widget.productModel);
                      }
                      await ProductDetailFirestore()
                          .updateProductRating(widget.productModel);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setSp(10),
                        vertical: ScreenUtil().setSp(5),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ScreenUtil().setSp(
                            15,
                          ),
                        ),
                        color: logoColor,
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(17.5),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(
        () => ModalProgressHUD(
          inAsyncCall: Get.find<LoginController>().processing.value,
          progressIndicator: OurSpinner(),
          child: Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: darklogoColor,
                  size: ScreenUtil().setSp(25),
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                widget.productModel.name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  color: logoColor,
                  fontSize: ScreenUtil().setSp(20),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setSp(10),
                  left: ScreenUtil().setSp(10),
                  right: ScreenUtil().setSp(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: widget.heroTag,
                        child: Material(
                          type: MaterialType.transparency,
                          child: CarouselSlider(
                            items: widget.productModel.url
                                .map(
                                  (e) => Builder(
                                    builder: (context) => Image.network(
                                      e,
                                      height: ScreenUtil().setSp(220),
                                      fit: BoxFit.cover,
                                    ),

                                    //  CachedNetworkImage(
                                    //   height: ScreenUtil().setSp(220),
                                    //   fit: BoxFit.cover,
                                    //   imageUrl: e,
                                    //   placeholder: (context, url) =>
                                    //       Image.asset(
                                    //     "assets/images/placeholder.png",
                                    //     height: ScreenUtil().setSp(220),
                                    //     fit: BoxFit.cover,
                                    //   ),
                                    // ),
                                  ),
                                )
                                .toList(),
                            options: CarouselOptions(
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 1000),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              viewportFraction: 1,
                              height: ScreenUtil().setSp(200),
                            ),
                          ),
                        ),
                      ),
                      OurSizedBox(),
                      Hero(
                        tag: "NameTag-${widget.heroTag}",
                        child: Material(
                          type: MaterialType.transparency,
                          child: Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                widget.productModel.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0,
                                  color: logoColor,
                                  fontSize: ScreenUtil().setSp(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      OurSizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Hero(
                              tag: "ShopName-${widget.heroTag}",
                              // tag: "ShopName-$key",
                              child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  onTap: () async {
                                    DocumentSnapshot abc =
                                        await FirebaseFirestore.instance
                                            .collection("Sellers")
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .get();
                                    UserModel userModel =
                                        UserModel.fromMap(abc);
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        child: ShoppingShopProfileScreen(
                                          userModel: userModel,
                                          shopName:
                                              widget.productModel.shop_name,
                                          shopOwnerUID:
                                              widget.productModel.ownerUid,
                                        ),
                                        type: PageTransitionType.leftToRight,
                                      ),
                                    );
                                    // print("Button Pressed");
                                  },
                                  child: Text(
                                    widget.productModel.shop_name,
                                    style: TextStyle(
                                      color: darklogoColor,
                                      fontSize: ScreenUtil().setSp(17.5),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      OurSizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              // color: Colors.red,
                              child: Hero(
                                tag: "Price-${widget.heroTag}",
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    "Rs. ${widget.productModel.price}",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(17.5),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Hero(
                              tag: "Rating-${widget.heroTag}",
                              child: Material(
                                type: MaterialType.transparency,
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("All")
                                      .where("uid",
                                          isEqualTo: widget.productModel.uid)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      ProductModel productModel1 =
                                          ProductModel.fromMap(
                                              snapshot.data!.docs[0]);
                                      return Row(
                                        children: [
                                          RatingStars(
                                            value:
                                                productModel1.rating.toDouble(),
                                            starBuilder: (index, color) => Icon(
                                              Icons.star,
                                              color: color,
                                              size: ScreenUtil().setSp(17),
                                            ),
                                            starCount: 5,
                                            starSize: ScreenUtil().setSp(17.5),
                                            valueLabelColor:
                                                const Color(0xff9b9b9b),
                                            valueLabelTextStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              fontSize:
                                                  ScreenUtil().setSp(13.5),
                                            ),
                                            valueLabelRadius:
                                                ScreenUtil().setSp(20),
                                            maxValue: 5,
                                            starSpacing: 1,
                                            maxValueVisibility: true,
                                            valueLabelVisibility: true,
                                            animationDuration: const Duration(
                                                milliseconds: 800),
                                            valueLabelPadding:
                                                EdgeInsets.symmetric(
                                              vertical: ScreenUtil().setSp(7.5),
                                              horizontal:
                                                  ScreenUtil().setSp(7.5),
                                            ),
                                            valueLabelMargin: EdgeInsets.only(
                                              right: ScreenUtil().setSp(3),
                                            ),
                                            starOffColor: Colors.white,
                                            starColor: darklogoColor,
                                          ),
                                          Text(
                                            "(${productModel1.ratingNo.toString()})",
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(13),
                                              fontWeight: FontWeight.w500,
                                              color: darklogoColor,
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Row(
                                        children: [
                                          RatingStars(
                                            value: widget.productModel.rating
                                                .toDouble(),
                                            starBuilder: (index, color) => Icon(
                                              Icons.star,
                                              color: color,
                                              size: ScreenUtil().setSp(17),
                                            ),
                                            starCount: 5,
                                            starSize: ScreenUtil().setSp(17.5),
                                            valueLabelColor:
                                                const Color(0xff9b9b9b),
                                            valueLabelTextStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              fontSize:
                                                  ScreenUtil().setSp(13.5),
                                            ),
                                            valueLabelRadius:
                                                ScreenUtil().setSp(20),
                                            maxValue: 5,
                                            starSpacing: 1,
                                            maxValueVisibility: true,
                                            valueLabelVisibility: true,
                                            animationDuration: const Duration(
                                                milliseconds: 800),
                                            valueLabelPadding:
                                                EdgeInsets.symmetric(
                                              vertical: ScreenUtil().setSp(7.5),
                                              horizontal:
                                                  ScreenUtil().setSp(7.5),
                                            ),
                                            valueLabelMargin: EdgeInsets.only(
                                              right: ScreenUtil().setSp(3),
                                            ),
                                            starOffColor: Colors.white,
                                            starColor: darklogoColor,
                                          ),
                                          Text(
                                            "(${widget.productModel.ratingNo.toString()})",
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(13),
                                              fontWeight: FontWeight.w500,
                                              color: darklogoColor,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      OurSizedBox(),
                      ReadMoreText(
                        widget.productModel.desc,
                        trimLines: 2,
                        // colorClickableText: Colors.pink,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: ' Show more',
                        trimExpandedText: ' Show less',
                        style: TextStyle(
                          color: logoColor,
                          fontSize: ScreenUtil().setSp(16.5),
                          fontWeight: FontWeight.w400,
                        ),
                        moreStyle: TextStyle(
                          color: darklogoColor,
                          fontSize: ScreenUtil().setSp(16.5),
                          fontWeight: FontWeight.w600,
                        ),
                        lessStyle: TextStyle(
                          color: darklogoColor,
                          fontSize: ScreenUtil().setSp(16.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      OurSizedBox()

                      // OurRecommendationWidget(
                      //   productUIDhide: widget.productModel.uid,
                      // ),
                      // OurSizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

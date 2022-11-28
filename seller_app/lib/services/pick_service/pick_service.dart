import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myapp/models/my_order_request_product.dart';
import 'package:myapp/widget/our_flutter_toast.dart';

import '../../controller/login_controller.dart';
import '../notification_service/notification_service.dart';

class PickService {
  addPickedService(MyOrderRequestProduct myOrderRequestProduct) async {
    Get.find<LoginController>().toggle(true);
    try {
      await FirebaseFirestore.instance
          .collection("RequestOrder")
          .doc(myOrderRequestProduct.requestId)
          .update({
        "ispicked": true,
      }).then((value) async {
        var userData = await FirebaseFirestore.instance
            .collection("Users")
            .doc(myOrderRequestProduct.requestUserId)
            .get();
        var data = userData.data()!["token"];
        await NotificationService().sendNotification(
            "Order packed",
            "${myOrderRequestProduct.productName} is packed",
            "userModel.profile_pic",
            "",
            data);
      });
      OurToast().showSuccessToast("Item Picked");
      // });
      Get.find<LoginController>().toggle(false);
    } catch (e) {
      print(e);
      Get.find<LoginController>().toggle(false);
    }
  }
}

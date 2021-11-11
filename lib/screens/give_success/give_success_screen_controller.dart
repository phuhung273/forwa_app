import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/base_controller/rating_controller.dart';
import 'package:get/get.dart';

class GiveSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GiveSuccessScreenController());
  }
}

const customerNameParam = 'customer_name';

class GiveSuccessScreenController extends RatingController {

  String? customerName;

  @override
  void onInit(){
    super.onInit();

    customerName = Get.parameters[customerNameParam];
  }

  @override
  void onReady(){
    super.onReady();

    if(customerName == null) return;
    showRatingDialog(customerName!);
  }

  void submit() {
    Get.offAndToNamed(ROUTE_MAIN);
  }
}
import 'package:forwa_app/route/route.dart';
import 'package:get/get.dart';

class IntroScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IntroScreenController());
  }
}

class IntroScreenController extends GetxController {

  void done() {
    Get.offAndToNamed(ROUTE_MAIN);
  }

  void doneAndNeverShowAgain() {
    Get.offAndToNamed(ROUTE_MAIN);
  }
}
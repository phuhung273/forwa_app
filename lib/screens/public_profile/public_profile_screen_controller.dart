import 'package:get/get.dart';

class PublicProfileScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PublicProfileScreenController());
  }
}

class PublicProfileScreenController extends GetxController {
}
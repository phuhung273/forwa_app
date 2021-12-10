import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/policy/policy_screen.dart';
import 'package:get/get.dart';

class IntroScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IntroScreenController());
  }
}

class IntroScreenController extends GetxController {

  final LocalStorage _localStorage = Get.find();

  void done() {
    _checkEULA();
  }

  void doneAndNeverShowAgain() {
    _checkEULA();
  }

  _checkEULA(){
    if(_localStorage.getAgreeTerm() == null){
      Get.to(() =>
          PolicyScreen(
              onAgree: () => Get.offAllNamed(ROUTE_MAIN)
          )
      );
    } else {
      Get.offAllNamed(ROUTE_MAIN);
    }
  }
}
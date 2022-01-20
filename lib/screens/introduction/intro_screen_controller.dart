import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/base_controller/individual_screen_controller.dart';
import 'package:forwa_app/screens/policy/policy_screen.dart';
import 'package:get/get.dart';

class IntroScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IntroScreenController());
  }
}

class IntroScreenController extends IndividualScreenController {

  @override
  String get screenName => ROUTE_INTRODUCTION;

  final LocalStorage _localStorage = Get.find();

  @override
  void onReady() {
    super.onReady();

    analyticService.logTutorialBegin();
  }

  void done() {
    analyticService.logTutorialComplete();
    _checkEULA();
  }

  void doneAndNeverShowAgain() {
    _localStorage.saveSkipIntro();
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
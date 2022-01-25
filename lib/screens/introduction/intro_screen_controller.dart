import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/di/analytics/analytic_service.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/policy/policy_screen.dart';
import 'package:get/get.dart';

class IntroScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IntroScreenController());
  }
}

class IntroScreenController extends BaseController {
  final AnalyticService _analyticService = Get.find();

  final LocalStorage _localStorage = Get.find();

  @override
  void onReady() {
    super.onReady();

    _analyticService.logTutorialBegin();
  }

  void done() {
    _analyticService.logTutorialComplete();
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
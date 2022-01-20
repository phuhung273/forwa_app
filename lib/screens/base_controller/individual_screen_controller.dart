
import 'package:forwa_app/di/analytics/analytic_service.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:get/get.dart';

abstract class IndividualScreenController extends BaseController {

  final AnalyticService analyticService = Get.find();

  String get screenName;

  @override
  void onReady() {
    super.onReady();

    analyticService.setCurrentScreen(screenName);
  }
}

import 'package:forwa_app/di/analytics/analytic_service.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/base_controller/navigation_controller.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

abstract class MainTabController extends BaseController{

  bool loggedIn = false;

  final NavigationController _navigationController = Get.find();
  final AnalyticService analyticService = Get.find();

  int get pageIndex;

  @override
  void onInit(){
    super.onInit();

    _navigationController.reloadStream.listen((event) {
      if(event){
        cleanData();
        loggedIn = false;
      }
    });

    _navigationController.tabStream.listen((event) async {
      if(event == pageIndex){

        switch(event){
          case MY_GIVINGS_SCREEN_INDEX:
            analyticService.setCurrentScreen(ROUTE_MY_GIVING);
            break;
          case MY_RECEIVINGS_SCREEN_INDEX:
            analyticService.setCurrentScreen(ROUTE_MY_RECEIVING);
            break;
          case CHAT_SCREEN_INDEX:
            analyticService.setCurrentScreen(ROUTE_CHAT);
            break;
          case NOTIFICATION_SCREEN_INDEX:
            analyticService.setCurrentScreen(ROUTE_NOTIFICATION);
            break;
        }

        if(!loggedIn){
          final result = await authCheck();
          if(result){
            loggedIn = true;
          }
        }
      }
    });
  }

  Future main();

  Future authorizedMain() async {
    if(!isAuthorized()) return;
    await main();
  }

  bool isAuthorized();
  void cleanData();

  @override
  Future<bool> onReady() async {
    super.onReady();
    return authCheck();
  }

  Future<bool> authCheck() async {
    if(!isAuthorized()){
      showLoginDialog();
      return false;
    }

    showLoadingDialog();
    await main();
    hideDialog();

    return true;
  }
}
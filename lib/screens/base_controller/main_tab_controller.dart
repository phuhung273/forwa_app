
import 'package:forwa_app/screens/base_controller/navigation_controller.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

abstract class MainTabController extends BaseController{

  bool loggedIn = false;

  final NavigationController _navigationController = Get.find();

  int get pageIndex;

  @override
  void onInit(){
    super.onInit();

    _navigationController.authStream.listen((event) {
      final willReset = event as bool;
      if(willReset){
        cleanData();
        loggedIn = false;
      }
    });

    _navigationController.tabStream.listen((event) async {
      final page = event as int;
      if(page == pageIndex){
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
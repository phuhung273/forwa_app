import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/auth_repo.dart';
import 'package:forwa_app/di/firebase_messaging_service.dart';
import 'package:forwa_app/di/notification_service.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/auth/logout_request.dart';
import 'package:forwa_app/screens/base_controller/address_controller.dart';
import 'package:forwa_app/screens/base_controller/app_notification_controller.dart';
import 'package:forwa_app/screens/base_controller/navigation_controller.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/base_controller/chat_controller.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:forwa_app/screens/my_givings/my_giving_screen_controller.dart';
import 'package:forwa_app/screens/my_receivings/my_receivings_screen_controller.dart';
import 'package:forwa_app/screens/policy/policy_upload_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainScreenController());
    Get.lazyPut(() => AppNotificationController());
    Get.lazyPut(() => FirebaseMessagingService());
    Get.put(MyGivingsScreenController());
    Get.put(MyReceivingsScreenController());
    Get.put(AddressController());
  }
}

class MainScreenController extends BaseController {

  final LocalStorage _localStorage = Get.find();

  final GoogleSignIn _googleSignIn = Get.find();

  final AuthRepo _authRepo = Get.find();

  final ChatController _chatController = Get.find();
  final NavigationController _navigationController = Get.find();

  final AppNotificationController _appNotificationController = Get.find();

  final FirebaseMessagingService _firebaseMessagingService = Get.find();
  final NotificationService _notificationService = Get.find();

  final drawerController = AdvancedDrawerController();

  final pageController = PageController();

  var pageIndex = 0.obs;

  final avatar = ''.obs;
  final fullname = ''.obs;

  @override
  void onInit() {
    super.onInit();
    refreshCredential();

    _notificationService.init();
    _firebaseMessagingService.init();

    _navigationController.tabStream.listen((event) async {
      _onChangeTab(event);
    });
  }

  @override
  void onReady() {
    super.onReady();

    _chatController.fetchUnread();
  }

  void refreshCredential(){
    avatar.value = _localStorage.getAvatarUrl() ?? '';
    fullname.value = _localStorage.getCustomerName() ?? '';
  }

  void changeTab(int value) {
    _navigationController.changeTab(value);
  }

  void _onChangeTab(int value){
    drawerController.hideDrawer();
    pageIndex.value = value;
    pageController.jumpToPage(value);

    switch(value){
      case NOTIFICATION_SCREEN_INDEX:
        _appNotificationController.readMyNotification();
        break;
      case MY_RECEIVINGS_SCREEN_INDEX:
        _appNotificationController.readMyReceiving();
        break;
      case MY_GIVINGS_SCREEN_INDEX:
        _appNotificationController.readMyGiving();
        break;
      default:
        break;
    }
  }

  void openDrawer(){
    drawerController.showDrawer();
  }

  Future logout() async {

    final deviceName = _localStorage.getDeviceName();
    if(deviceName == null){
      return;
    }

    if(_localStorage.getUserID() == null) return;

    showLoadingDialog();
    final request = LogoutRequest(deviceName: deviceName);
    final response = await _authRepo.logout(request);
    hideDialog();

    if(!response.isSuccess || response.data == null){
      return;
    }

    try{
      FacebookAuth.instance.logOut();
      _googleSignIn.disconnect();
    }catch(e){
    }

    _localStorage.removeCredentials();
    drawerController.hideDrawer();
    refreshCredential();
    _chatController.reset();
    _navigationController.reset();
  }

  void toGiveScreen(){
    if(_localStorage.getAgreeUploadTerm() == null){
      Get.to(() =>
        PolicyUploadScreen(
          onAgree: () => Get.offNamed(ROUTE_GIVE)
        )
      );
    } else {
      Get.toNamed(ROUTE_GIVE);
    }
  }
}
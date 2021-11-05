import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainScreenController());
  }
}

class MainScreenController extends GetxController {

  final LocalStorage _localStorage = Get.find();

  final GoogleSignIn _googleSignIn = Get.find();

  final drawerController = AdvancedDrawerController();

  var pageIndex = 0.obs;

  final avatar = ''.obs;
  final fullname = ''.obs;


  @override
  void onInit() {
    super.onInit();
    refreshCredential();
  }

  void refreshCredential(){
    avatar.value = _localStorage.getAvatarUrl() ?? '';
    fullname.value = _localStorage.getUsername() ?? '';
  }

  void changeTab(int value) {
    pageIndex.value = value;
  }

  void openDrawer(){
    drawerController.showDrawer();
  }

  Future logout() async {
    try{
      await FacebookAuth.instance.logOut();
      await _googleSignIn.disconnect();
    }catch(e){
    }
    _localStorage.removeCredentials();
    drawerController.hideDrawer();
    refreshCredential();
  }
}
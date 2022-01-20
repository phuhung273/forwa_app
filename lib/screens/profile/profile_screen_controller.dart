import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/base_controller/individual_screen_controller.dart';
import 'package:get/get.dart';

class ProfileScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileScreenController());
  }
}

class ProfileScreenController extends IndividualScreenController {

  @override
  String get screenName => ROUTE_PROFILE;

  final LocalStorage _localStorage = Get.find();

  final fullname = ''.obs;
  final avatar = ''.obs;

  @override
  void onInit() {
    super.onInit();

    refreshCredential();
  }

  void refreshCredential(){
    avatar.value = _localStorage.getAvatarUrl() ?? '';
    fullname.value = _localStorage.getCustomerName() ?? '';
  }
}
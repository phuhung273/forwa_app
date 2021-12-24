import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:get/get.dart';

class ProfileScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileScreenController());
  }
}

class ProfileScreenController extends GetxController {

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
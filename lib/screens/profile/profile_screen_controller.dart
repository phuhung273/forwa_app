import 'package:flutter/cupertino.dart';
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    final name = _localStorage.getCustomerName() ?? '';
    final email = _localStorage.getUsername() ?? '';
    final phone = _localStorage.getPhone() ?? '';

    nameController.text = name;
    emailController.text = email;
    phoneController.text = phone;
  }
}
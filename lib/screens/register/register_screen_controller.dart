import 'package:flutter/cupertino.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/remote/auth_service.dart';
import 'package:forwa_app/datasource/repository/auth_repo.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/auth/register_request.dart';
import 'package:forwa_app/schema/customer/customer.dart';
import 'package:forwa_app/screens/base_controller.dart';
import 'package:get/get.dart';

class RegisterScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterScreenController());
  }
}

class RegisterScreenController extends BaseController {

  final AuthRepo _authRepo = Get.find();

  var result = ''.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();

  Future register() async {
    showLoadingDialog();

    final words = nameController.text.split(' ');

    final request = RegisterRequest(
      customer: Customer(
        firstName: words.first,
        lastName: words.length > 1 ? words.last : words.first,
        email: emailController.text,
      ),
      password: pwdController.text
    );

    final response = await _authRepo.register(request);

    hideDialog();

    if(!response.isSuccess){
      result.value = response.message!;
    } else {
      Get.offAndToNamed(ROUTE_LOGIN);
    }
  }
}
import 'package:flutter/cupertino.dart';
import 'package:forwa_app/datasource/repository/auth_repo.dart';
import 'package:forwa_app/helpers/phone_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/auth/email_register_request.dart';
import 'package:forwa_app/screens/base_controller/otp_controller.dart';
import 'package:get/get.dart';

class RegisterScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterScreenController());
  }
}

class RegisterScreenController extends OtpController {

  final AuthRepo _authRepo = Get.find();

  var result = ''.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController methodController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();

  Future register() async {

    final method = methodController.text;
    if(method.isValidEmail()){
      await emailRegister();
    } else {
      await phoneRegister();
    }

  }

  Future emailRegister() async {
    showLoadingDialog();

    final request = EmailRegisterRequest(
      name: nameController.text,
      email: methodController.text,
      password: pwdController.text,
      passwordConfirmation: pwdController.text,
    );

    final response = await _authRepo.emailRegister(request);

    hideDialog();

    if(!response.isSuccess){
      result.value = response.message!;
    } else {
      Get.offAndToNamed(ROUTE_LOGIN);
    }
  }

  Future phoneRegister() async {
    final phone = formatPhoneNumber(methodController.text);
    showLoadingDialog();

    showOtpDialog(
      phone: phone,
      onSuccess: (){
        hideDialog();
        print('success');
      },
      onError: (){
        hideDialog();
        print('error');
      }
    );
    // showLoadingDialog();
    //
    // final request = EmailRegisterRequest(
    //   name: nameController.text,
    //   email: methodController.text,
    //   password: pwdController.text,
    //   passwordConfirmation: pwdController.text,
    // );
    //
    // final response = await _authRepo.emailRegister(request);
    //
    // hideDialog();
    //
    // if(!response.isSuccess){
    //   result.value = response.message!;
    // } else {
    //   Get.offAndToNamed(ROUTE_LOGIN);
    // }
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
import 'package:flutter/cupertino.dart';
import 'package:forwa_app/datasource/repository/auth_repo.dart';
import 'package:forwa_app/datasource/repository/otp_repo.dart';
import 'package:forwa_app/helpers/email_helper.dart';
import 'package:forwa_app/helpers/phone_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/auth/email_register_request.dart';
import 'package:forwa_app/schema/auth/phone_register_request.dart';
import 'package:forwa_app/schema/otp/firebase_otp_request.dart';
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
  final OtpRepo _otpRepo = Get.find();

  var result = ''.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController methodController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();

  Future register() async {

    final method = methodController.text;
    if(isValidEmail(method)){
      await emailRegister();
    } else {
      await phoneVerify();
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

  Future phoneVerify() async {
    final phone = formatPhoneNumber(methodController.text);

    final request = FirebaseOtpRequest(phone: phone);

    showLoadingDialog();
    final response = await _otpRepo.sendSmsCode(request);

    if(!response.isSuccess || response.data == null){
      hideDialog();
      //TODO: show error message
      return;
    }

    final result = await showOtpDialog(phone: phone, sessionInfo: response.data!.sessionInfo);

    hideDialog();
    if(result == null || !result){
      return;
    }

    await phoneRegister();
  }

  Future phoneRegister() async {
    showLoadingDialog();

    final request = PhoneRegisterRequest(
      name: nameController.text,
      phone: formatPhoneNumber(methodController.text),
      password: pwdController.text,
      passwordConfirmation: pwdController.text,
    );

    final response = await _authRepo.phoneRegister(request);

    hideDialog();

    if(!response.isSuccess){
      result.value = response.message!;
    } else {
      Get.offAndToNamed(ROUTE_LOGIN);
    }
  }
}
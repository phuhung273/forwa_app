import 'package:flutter/cupertino.dart';
import 'package:form_validator/form_validator.dart';
import 'package:forwa_app/datasource/repository/auth_repo.dart';
import 'package:forwa_app/helpers/phone_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/auth/email_register_request.dart';
import 'package:forwa_app/schema/auth/phone_register_request.dart';
import 'package:forwa_app/screens/base_controller/otp_controller.dart';
import 'package:get/get.dart';

class RegisterScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterScreenController());
  }
}

enum RegisterMethod{
  PHONE,
  EMAIL,
}

class RegisterScreenController extends OtpController {

  final AuthRepo _authRepo = Get.find();

  var result = ''.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController methodController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();
  final TextEditingController pwdConfirmController = TextEditingController();

  Future register() async {

    if(pwdController.text != pwdConfirmController.text){
      showErrorDialog(message: errorCodeMap['USER_003']!);
      return;
    }

    final method = methodController.text;
    if(ValidationBuilder().email().test(method) == null){
      await emailRegister();
    } else if(ValidationBuilder().phone().test(method) == null) {
      phoneVerify();
    }

  }

  Future emailRegister() async {
    showLoadingDialog();

    final request = EmailRegisterRequest(
      name: nameController.text,
      email: methodController.text,
      password: pwdController.text,
      passwordConfirmation: pwdConfirmController.text,
    );

    final response = await _authRepo.emailRegister(request);

    hideDialog();

    _processRegisterResponse(response, RegisterMethod.EMAIL);
  }

  void phoneVerify() {
    final phone = formatPhoneNumber(methodController.text);
    showLoadingDialog();

    verifyOtp(
      phone: phone,
      onSuccess: () {
        hideDialog();
        phoneRegister();
      }
    );
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

    _processRegisterResponse(response, RegisterMethod.PHONE);
  }

  Future _processRegisterResponse(ApiResponse response, RegisterMethod method) async{
    if(!response.isSuccess){
      final message = errorCodeMap[response.statusCode] ?? 'Lỗi không xác định';
      result.value = message;
      showErrorDialog(message: message);
      return;
    }

    final message = successMessageMap[method] ?? 'Đăng ký thành công';
    await showSuccessDialog(message: message);

    Get.back();
  }
}
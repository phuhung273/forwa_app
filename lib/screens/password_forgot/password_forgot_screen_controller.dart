import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/remote/password_service.dart';
import 'package:forwa_app/datasource/repository/password_repo.dart';
import 'package:forwa_app/helpers/email_helper.dart';
import 'package:forwa_app/helpers/phone_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/password/forgot_password_email_request.dart';
import 'package:forwa_app/schema/password/forgot_password_phone_request.dart';
import 'package:forwa_app/screens/base_controller/otp_controller.dart';
import 'package:forwa_app/screens/password_reset/password_reset_screen_controller.dart';
import 'package:get/get.dart';

class PasswordForgotScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PasswordForgotScreenController());
    Get.lazyPut(() => PasswordService(Get.find()));
    Get.lazyPut(() => PasswordRepo());
  }
}

enum ForgotPasswordMethod{
  email,
  phone,
}

class PasswordForgotScreenController extends OtpController {

  @override
  String get screenName => ROUTE_PASSWORD_FORGOT;

  final PasswordRepo _passwordRepo = Get.find();

  var result = ''.obs;

  final TextEditingController usernameController = TextEditingController();

  Future submit() async {
    final method = usernameController.text;
    if(isValidEmail(method)){
      await forgotByEmail();
    } else {
      await forgotByPhone();
    }
  }

  Future forgotByEmail() async {
    showLoadingDialog();

    final email = usernameController.text;

    final request = ForgotPasswordEmailRequest(
      email: email,
    );
    final response = await _passwordRepo.forgotPasswordByEmail(request);

    hideDialog();
    _processForgotResponse(response, ForgotPasswordMethod.email);
  }

  Future forgotByPhone() async {
    showLoadingDialog();

    final phone = formatPhoneNumber(usernameController.text);

    final request = ForgotPasswordPhoneRequest(
      phone: phone,
    );
    final response = await _passwordRepo.forgotPasswordByPhone(request);


    if(!response.isSuccess || response.data == null){
      hideDialog();
      final message = errorCodeMap[response.statusCode] ?? 'Lỗi không xác định';
      result.value = message;
      showErrorDialog(message: message);
      return;
    }

    verifyOtp(
      phone: phone,
      onSuccess: () {
        hideDialog();

        Get.toNamed(
          ROUTE_PASSWORD_RESET,
          parameters: {
            tokenParam: response.data!.token,
            phoneParam: phone,
          }
        );
      },
      previousRoute: ROUTE_PASSWORD_FORGOT
    );
  }

  Future _processForgotResponse(ApiResponse response, ForgotPasswordMethod method) async {
    if(!response.isSuccess){
      final message = errorCodeMap[response.statusCode] ?? 'Lỗi không xác định';
      result.value = message;
      showErrorDialog(message: message);
      return;
    }

    final message = successMessageMap[method] ?? 'Khôi phục mật khẩu thành công';
    await showSuccessDialog(message: message);

    Get.back();
  }
}
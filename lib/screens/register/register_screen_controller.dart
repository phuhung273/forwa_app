import 'package:flutter/cupertino.dart';
import 'package:form_validator/form_validator.dart';
import 'package:forwa_app/datasource/repository/auth_repo.dart';
import 'package:forwa_app/di/analytics/analytic_service.dart';
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
  phone,
  email,
}

class RegisterScreenController extends OtpController {

  @override
  String get screenName => ROUTE_REGISTER;

  final AuthRepo _authRepo = Get.find();

  final AnalyticService _analyticService = Get.find();

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
      _analyticService.logSignUpByEmail();
      await emailRegister();
    } else if(ValidationBuilder().phone().test(method) == null) {
      _analyticService.logSignUpByPhone();
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

    _processRegisterResponse(response, RegisterMethod.email);
  }

  void phoneVerify() {
    final phone = formatPhoneNumber(methodController.text);

    verifyOtp(
      phone: phone,
      onSuccess: () {
        phoneRegister();
      },
      previousRoute: ROUTE_REGISTER
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

    _processRegisterResponse(response, RegisterMethod.phone);
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
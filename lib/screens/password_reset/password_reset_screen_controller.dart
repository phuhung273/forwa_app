import 'package:flutter/cupertino.dart';
import 'package:forwa_app/datasource/repository/password_repo.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/password/reset_password_phone_request.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/password_forgot/password_forgot_screen_controller.dart';
import 'package:get/get.dart';

class PasswordResetScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PasswordResetScreenController());
  }
}

const tokenParam = 'token';
const phoneParam = 'phone';

class PasswordResetScreenController extends BaseController {

  final PasswordRepo _passwordRepo = Get.find();

  var result = ''.obs;

  final TextEditingController pwdController = TextEditingController();
  final TextEditingController pwdConfirmController = TextEditingController();

  String? _token;
  String? _phone;


  @override
  void onInit() {
    super.onInit();

    _token = Get.parameters[tokenParam];
    _phone = Get.parameters[phoneParam];
  }

  Future submit() async {
    if(_token == null || _phone == null){
      return;
    }

    final request = ResetPasswordPhoneRequest(
      phone: _phone!,
      password: pwdController.text,
      passwordConfirmation: pwdConfirmController.text,
      token: _token!
    );

    final response = await _passwordRepo.resetPasswordByPhone(request);

    if(!response.isSuccess){
      final message = errorCodeMap[response.statusCode] ?? 'Lỗi không xác định';
      result.value = message;
      showErrorDialog(message: message);
      return;
    }

    final message = successMessageMap[ForgotPasswordMethod.phone] ?? 'Khôi phục mật khẩu thành công';
    await showSuccessDialog(message: message);

    Get.until((route) => route.settings.name == ROUTE_LOGIN);
  }

  @override
  void onClose(){
    pwdController.dispose();
    pwdConfirmController.dispose();
    super.onClose();
  }
}
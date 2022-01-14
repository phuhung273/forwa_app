import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/helpers/email_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/input_field.dart';
import 'package:forwa_app/widgets/keyboard_friendly_body.dart';
import 'package:forwa_app/widgets/password_field.dart';
import 'package:get/get.dart';

import 'register_screen_controller.dart';

class RegisterScreen extends GetView<RegisterScreenController> {

  RegisterScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  void _validate() {
    if (_formKey.currentState!.validate()) {
      controller.register();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: KeyboardFriendlyBody(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: defaultPadding),
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.result.value, style: theme.textTheme.subtitle1),
                  const Divider(),
                  InputField(
                    hintText: 'Họ tên',
                    icon: Icons.person,
                    autofillHints: const [AutofillHints.name],
                    controller: controller.nameController,
                    textCapitalization: TextCapitalization.words,
                    validator: ValidationBuilder(requiredMessage: 'Vui lòng nhập họ tên')
                      .minLength(6, 'Họ tên quá ngắn')
                      .build(),
                  ),
                  InputField(
                    hintText: 'Email hoặc Điện thoại',
                    autofillHints: const [AutofillHints.email, AutofillHints.telephoneNumber],
                    icon: Icons.verified_user,
                    controller: controller.methodController,
                    textCapitalization: TextCapitalization.none,
                    validator: ValidationBuilder(requiredMessage: 'Vui lòng nhập tài khoản')
                      .emailOrPhone(
                        phoneMessage: 'Điện thoại không hợp lệ',
                        emailMessage: 'Email không hợp lệ'
                      )
                      .build(),
                  ),
                  PasswordField(
                    controller: controller.pwdController,
                    validator: ValidationBuilder(requiredMessage: 'Vui lòng nhập mật khẩu')
                      .build(),
                  ),
                  PasswordField(
                    controller: controller.pwdConfirmController,
                    hintText: 'Xác nhận mật khẩu',
                    validator: ValidationBuilder(requiredMessage: 'Vui lòng nhập lại mật khẩu')
                      .build(),
                  ),
                  AppLevelActionContainer(
                      child: ElevatedButton(
                        onPressed: _validate,
                        child: const Text('Đăng Ký'),
                      )
                  ),
                  const Divider(),
                  RichText(
                    text: TextSpan(
                      text: 'Đã có tài khoản? ',
                      style: theme.textTheme.subtitle1,
                      children: [
                        TextSpan(
                          text: 'Đăng nhập',
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = ()
                          => Get.toNamed(ROUTE_LOGIN)
                          ,
                        ),
                      ]
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension CustomValidationBuilder on ValidationBuilder {
  static final _numeric = RegExp(r'^-?[0-9]+$');
  static final _nonDigitsExp = RegExp(r'[^\d]');
  static final _anyLetter = RegExp(r'[A-Za-z]');
  static final _phoneRegExp = RegExp(r'^\d{7,15}$');

  emailOrPhone({String? phoneMessage, String? emailMessage}) => add((v) {

    if (_numeric.hasMatch(v!)) {
      return !_anyLetter.hasMatch(v) &&
          _phoneRegExp.hasMatch(v.replaceAll(_nonDigitsExp, ''))
          ? null
          : phoneMessage ?? 'Điện thoại không hợp lệ';
    } else {
      return isValidEmail(v) ? null : emailMessage ?? 'Email không hợp lệ';
    }
  });
}
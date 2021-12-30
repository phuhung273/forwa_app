import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/keyboard_friendly_body.dart';
import 'package:forwa_app/widgets/password_field.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import 'password_reset_screen_controller.dart';

class PasswordResetScreen extends GetView<PasswordResetScreenController> {

  PasswordResetScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  void _validate() {
    if (_formKey.currentState!.validate()) {
      controller.submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
                'Khôi phục mật khẩu'
            ),
          ),
          body: KeyboardFriendlyBody(
            padding: const EdgeInsets.all(defaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Text(controller.result.value, style: theme.textTheme.subtitle1)),
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
                  const Divider(),
                  AppLevelActionContainer(
                    child: ElevatedButton(
                      onPressed: _validate,
                      child: Text(
                        'Xác Nhận',
                        style: theme.textTheme.button!.copyWith(
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
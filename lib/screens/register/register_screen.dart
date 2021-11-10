import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/input_field.dart';
import 'package:forwa_app/widgets/keyboard_friendly_body.dart';
import 'package:forwa_app/widgets/password_field.dart';
import 'package:get/get.dart';

import 'register_screen_controller.dart';

class RegisterScreen extends GetView<RegisterScreenController> {

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        body: KeyboardFriendlyBody(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: defaultPadding),
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
                ),
                InputField(
                  hintText: 'Email',
                  icon: Icons.email,
                  autofillHints: const [AutofillHints.email],
                  controller: controller.emailController,
                ),
                PasswordField(
                  controller: controller.pwdController,
                ),
                AppLevelActionContainer(
                    child: ElevatedButton(
                      onPressed: controller.register,
                      child: const Text('Đăng Ký'),
                    )
                ),
                const Divider(),
                RichText(
                  text: TextSpan(
                    text: 'Đã có tài khoản? ',
                    style: theme.textTheme.headline6,
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
    );
  }
}
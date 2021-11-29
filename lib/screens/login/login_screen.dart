
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/input_field.dart';
import 'package:forwa_app/widgets/keyboard_friendly_body.dart';
import 'package:forwa_app/widgets/password_field.dart';
import 'package:get/get.dart';

import 'login_screen_controller.dart';

class LoginScreen extends GetView<LoginScreenController> {

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        body: KeyboardFriendlyBody(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: AutofillGroup(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Obx(() => Text(controller.result.value, style: theme.textTheme.subtitle1)),
                  const SizedBox(height: defaultSpacing * 5),
                  InputField(
                    hintText: 'Email hoặc Số điện thoại',
                    icon: Icons.person,
                    controller: controller.usernameController,
                    textCapitalization: TextCapitalization.none,
                  ),
                  PasswordField(
                    controller: controller.passwordController,
                  ),
                  AppLevelActionContainer(
                    child: ElevatedButton(
                      onPressed: controller.login,
                      child: Text(
                        'Đăng Nhập',
                        style: theme.textTheme.button!.copyWith(
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  RichText(
                    text: TextSpan(
                        text: 'Chưa có tài khoản? ',
                      style: theme.textTheme.subtitle1,
                      children: [
                        TextSpan(
                          text: 'Đăng ký',
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = ()
                            => Get.toNamed(ROUTE_REGISTER)
                          ,
                        ),
                      ]
                    ),
                  ),
                  AppLevelActionContainer(
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 2.0,
                            color: theme.colorScheme.surface,
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Text(
                            'Hoặc',
                            style: theme.textTheme.bodyText1,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 2.0,
                            color: theme.colorScheme.surface,
                          )
                        ),
                      ],
                    )
                  ),
                  AppLevelActionContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SocialButton(
                          text: 'Google',
                          icon: const FaIcon(
                            FontAwesomeIcons.google,
                            color: Color(0xffDF4A32),
                          ),
                          onTap: controller.googleLogin,
                        ),
                        SocialButton(
                          text: 'Facebook',
                          icon: const FaIcon(
                            FontAwesomeIcons.facebook,
                            color: Color(0xff39579A),
                          ),
                          onTap: controller.facebookLogin,
                        ),
                      ],
                    )
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

class SocialButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onTap;
  const SocialButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: icon,
          iconSize: 48.0,
        ),
        Text(text, style: theme.textTheme.bodyText1),
      ],
    );
  }
}


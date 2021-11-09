import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/input_field.dart';
import 'package:forwa_app/widgets/keyboard_friendly_body.dart';
import 'package:get/get.dart';

import 'profile_screen_controller.dart';

class ProfileScreen extends GetView<ProfileScreenController> {

  ProfileScreen({Key? key}) : super(key: key);

  final MainScreenController _mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        body: KeyboardFriendlyBody(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: defaultPadding),
          child: Column(
            children: [
              const ProfilePic(),
              const Divider(),
              InputField(
                hintText: 'Your Name',
                icon: Icons.person,
                controller: controller.nameController,
              ),
              InputField(
                hintText: 'Your Email',
                icon: Icons.email,
                controller: controller.emailController,
              ),
              InputField(
                hintText: 'Your Phone',
                icon: Icons.smartphone,
                controller: controller.phoneController,
              ),
              AppLevelActionContainer(
                child: ElevatedButton.icon(
                  onPressed: () {  },
                  icon: const Icon(Icons.save),
                  label: const Text('Lưu thay đổi'),
                )
              ),
              ProfileAction(
                icon: Icons.home,
                text: 'Địa chỉ',
                onTap: () => Get.toNamed(ROUTE_PROFILE_ADDRESS),
              ),
              // ProfileAction(
              //   icon: Icons.lock,
              //   text: 'Đổi mật khẩu',
              //   onTap: () { },
              // ),
              ProfileAction(
                icon: Icons.logout,
                text: 'Đăng xuất',
                onTap: () async {
                  await _mainController.logout();
                  Get.back();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileAction extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const ProfileAction({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppLevelActionContainer(
      child: ListTile(
        leading: Icon(
          icon,
          color: theme.colorScheme.secondaryVariant,
        ),
        title: Text(
          text,
          style: theme.textTheme.headline6?.copyWith(
            color: Colors.grey,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}


class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<String> words = 'Tran Pham Phu Hung'.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            child: Text(
              shortWords.map((e) => e[0]).join(),
              style: theme.textTheme.headline6!.copyWith(
                color: Colors.white,
              ),
            ),
            backgroundColor: theme.colorScheme.secondary,
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  primary: Colors.grey,
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {},
                child: const Icon(Icons.photo_camera),
              ),
            ),
          )
        ],
      ),
    );
  }
}
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
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
        appBar: AppBar(
          title: const Text('Tài khoản'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: defaultPadding),
          child: Column(
            children: [
              const ProfilePic(),
              const Divider(),
              Obx(
                () => Text(
                  controller.fullname.value,
                  style: theme.textTheme.headline6,
                ),
              ),
              const Divider(),
              ProfileAction(
                icon: Icons.account_circle,
                text: 'Hồ sơ',
                onTap: () => Get.toNamed(ROUTE_PROFILE_EDIT),
              ),
              ProfileAction(
                icon: Icons.home,
                text: 'Địa chỉ',
                onTap: () => Get.toNamed(ROUTE_PROFILE_ADDRESS),
              ),
              ProfileAction(
                icon: Icons.email,
                text: 'Cập nhật email',
                onTap: () { },
              ),
              ProfileAction(
                icon: Icons.smartphone,
                text: 'Cập nhật số điện thoại',
                onTap: () { },
              ),
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
          style: theme.textTheme.subtitle1
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

const IMAGE_SIZE = 115.0;

class ProfilePic extends GetView<ProfileScreenController> {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: IMAGE_SIZE,
      width: IMAGE_SIZE,
      child: Obx(
        () {
          if(controller.avatar.isEmpty){

            final List<String> words = controller.fullname.split(' ');
            final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

            return CircleAvatar(
              radius: IMAGE_SIZE,
              child: Text(
                shortWords.map((e) => e[0]).join(),
                style: theme.textTheme.headline6!.copyWith(
                  color: Colors.white,
                ),
              ),
              backgroundColor: theme.colorScheme.secondary,
            );
          }

          return ExtendedImage.network(
            controller.avatar.value,
            fit: BoxFit.cover,
            shape: BoxShape.circle,
          );
        }
      ),
    );
  }
}
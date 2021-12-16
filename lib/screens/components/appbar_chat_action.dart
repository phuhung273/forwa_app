import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/screens/base_controller/chat_controller.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:get/get.dart';

class AppBarChatAction extends GetView<ChatController> {
  final MainScreenController _mainController = Get.find();
  AppBarChatAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Obx(
        () {
          return controller.unreadMessageCount.value != 0
            ? Badge(
              padding: const EdgeInsets.all(6.0),
              badgeContent: Text(
                controller.unreadMessageCount.string,
                style: theme.textTheme.subtitle1?.copyWith(
                    color: theme.colorScheme.onSecondary
                ),
              ),
              animationType: BadgeAnimationType.scale,
              position: BadgePosition.topStart(),
              child: _buildInnerIcon(),
            )
            : _buildInnerIcon();
        },
      ),
    );
  }

  Widget _buildInnerIcon(){
    return IconButton(
      icon: const Icon(
        Icons.textsms,
      ),
      iconSize: 20.0,
      onPressed: () => _mainController.changeTab(CHAT_SCREEN_INDEX),
    );
  }
}
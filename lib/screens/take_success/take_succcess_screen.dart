import 'package:flutter/material.dart';
import 'package:forwa_app/screens/take_success/take_success_screen_controller.dart';
import 'package:forwa_app/widgets/app_container.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/body_with_persistent_bottom.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class TakeSuccessScreen extends GetView<TakeSuccessScreenController> {

  const TakeSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pictureWidth = size.width * 0.8;
    final theme = Theme.of(context);
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return SafeArea(
        child: Scaffold(
          body: BodyWithPersistentBottom(
              isKeyboard: isKeyboard,
              child: Column(
                children: [
                  Divider(
                    height: size.height * 0.2,
                  ),
                  Lottie.asset(
                    'assets/animations/11504-birthday.json',
                    width: pictureWidth,
                    height: pictureWidth,
                    fit: BoxFit.fill,
                  ),
                  AppContainer(
                    child: Text(
                      'Trân trọng tấm lòng của người khác',
                      style: theme.textTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              bottom: AppLevelActionContainer(
                child: ElevatedButton(
                  onPressed: controller.submit,
                  child: const Text('Hoàn tất'),
                ),
              )
          ),
        )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/body_with_persistent_bottom.dart';
import 'package:forwa_app/widgets/image_gallery_picker.dart';
import 'package:forwa_app/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:time_range/time_range.dart';

import 'give_screen_controller.dart';

class GiveScreen extends GetView<GiveScreenController> {

  const GiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tải lên'),
        ),
        body: BodyWithPersistentBottom(
          isKeyboard: isKeyboard,
          child: Column(
            children: [
              const Divider(),
              ImageGalleryPicker(
                onPick: (file) => controller.addImage(file),
                onDelete: controller.deleteImage,
              ),
              InputField(
                hintText: 'Tên đồ vật',
                icon: Icons.card_giftcard,
                controller: controller.nameController,
              ),
              InputField(
                hintText: 'Mô tả',
                icon: Icons.edit,
                controller: controller.descriptionController,
                maxLines: 3,
              ),
              // InputField(
              //   hintText: 'Giờ có thể lấy',
              //   icon: Icons.schedule,
              //   controller: controller.address1Controller,
              // ),
              AppLevelActionContainer(
                child: TimeRange(
                  fromTitle: Text(
                    'Có thể tới lấy từ',
                    style: theme.textTheme.subtitle1,
                  ),
                  toTitle: Text(
                    'Tới',
                    style: theme.textTheme.subtitle1,
                  ),
                  titlePadding: 20,
                  textStyle: theme.textTheme.bodyText1,
                  activeTextStyle: theme.textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.transparent,
                  activeBackgroundColor: theme.colorScheme.secondary,
                  firstTime: const TimeOfDay(hour: 0, minute: 00),
                  lastTime: const TimeOfDay(hour: 23, minute: 00),
                  timeStep: 60,
                  timeBlock: 60,
                  initialRange: initialPickupTime,
                  onRangeCompleted: (range) => controller.time = range,
                ),
              )
            ],
          ),
          bottom: AppLevelActionContainer(
            child: ElevatedButton(
              onPressed: controller.submit,
              child: const Text('Gửi Lên'),
            ),
          )
        ),
      ),
    );
  }
}


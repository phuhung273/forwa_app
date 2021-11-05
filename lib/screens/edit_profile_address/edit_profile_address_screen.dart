import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/input_field.dart';
import 'package:forwa_app/widgets/keyboard_friendly_body.dart';
import 'package:get/get.dart';

import 'edit_profile_address_screen_controller.dart';

class EditProfileAddressScreen extends GetView<EditProfileAddressController> {
  const EditProfileAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chỉnh sửa địa chỉ')
        ),
        body: KeyboardFriendlyBody(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              InputField(
                hintText: 'Đường',
                controller: controller.streetController,
              ),
              InputField(
                hintText: 'Phường/Xã',
                controller: controller.wardController,
              ),
              InputField(
                hintText: 'Quận/Huyện',
                controller: controller.districtController,
              ),
              InputField(
                hintText: 'Thành phố/Tỉnh',
                controller: controller.cityController,
              ),
              InputField(
                hintText: 'Điện thoại',
                icon: Icons.smartphone,
                controller: controller.phoneController,
              ),
              AppLevelActionContainer(
                  child: ElevatedButton.icon(
                    onPressed: controller.save,
                    icon: const Icon(Icons.save),
                    label: const Text('Lưu địa chỉ'),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
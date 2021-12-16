import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/input_field.dart';
import 'package:forwa_app/widgets/keyboard_friendly_body.dart';
import 'package:get/get.dart';

import 'edit_profile_address_screen_controller.dart';

class EditProfileAddressScreen extends GetView<EditProfileAddressController> {
  EditProfileAddressScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  void _validate() {
    if (_formKey.currentState!.validate()) {
      controller.save();
    }
  }

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
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                children: [
                  InputField(
                    hintText: 'Đường',
                    autofillHints: const [AutofillHints.streetAddressLevel1],
                    controller: controller.streetController,
                    textCapitalization: TextCapitalization.words,
                    validator: ValidationBuilder(requiredMessage: 'Ví dụ: 1 Lê Duẩn')
                        .build(),
                  ),
                  InputField(
                    hintText: 'Phường/Xã',
                    autofillHints: const [AutofillHints.streetAddressLevel2],
                    controller: controller.wardController,
                    textCapitalization: TextCapitalization.words,
                    validator: ValidationBuilder(requiredMessage: 'Ví dụ: Bến Nghé, Phường 1')
                        .build(),
                  ),
                  InputField(
                    hintText: 'Quận/Huyện',
                    autofillHints: const [AutofillHints.streetAddressLevel3],
                    controller: controller.districtController,
                    textCapitalization: TextCapitalization.words,
                    validator: ValidationBuilder(requiredMessage: 'Ví dụ: Gò Vấp, Quận 1')
                        .build(),
                  ),
                  InputField(
                    hintText: 'Thành phố/Tỉnh',
                    autofillHints: const [AutofillHints.addressCity],
                    controller: controller.cityController,
                    textCapitalization: TextCapitalization.words,
                    validator: ValidationBuilder(requiredMessage: 'Vui lòng nhập thành phố/tỉnh')
                        .build(),
                  ),
                  InputField(
                    hintText: 'Điện thoại',
                    autofillHints: const [AutofillHints.telephoneNumber],
                    controller: controller.phoneController,
                    validator: ValidationBuilder(requiredMessage: 'Vui lòng nhập điện thoại')
                        .phone('Số điện thoại không hợp lệ')
                        .build(),
                  ),
                  AppLevelActionContainer(
                    child: ElevatedButton.icon(
                      onPressed: _validate,
                      icon: const Icon(Icons.save),
                      label: const Text('Lưu địa chỉ'),
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
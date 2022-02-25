import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../widgets/app_level_action_container.dart';
import '../../../widgets/clearable_input_field.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/keyboard_friendly_body.dart';
import 'edit_address_controller.dart';

class EditAddressScreen<T extends EditAddressScreenController> extends GetView<T> {

  EditAddressScreen({Key? key}) : super(key: key);

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
              child: Obx(
                () => Column(
                  children: [
                    ClearableInputField(
                      icon: Icons.location_on,
                      hintText: 'Nhập địa chỉ',
                      controller: controller.addressController,
                      onClear: controller.clearAddress,
                    ),
                    if(controller.suggestions.isNotEmpty)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.suggestions.length,
                        itemBuilder: (context, index){
                          final suggestion = controller.suggestions[index];

                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(
                                Icons.pin_drop,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              suggestion.description!,
                              style: theme.textTheme.bodyText1,
                            ),
                            onTap: () => controller.selectSuggestions(suggestion),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    InputField(
                      icon: Icons.phone,
                      hintText: 'Điện thoại',
                      keyboardType: TextInputType.phone,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      controller: controller.phoneController,
                      validator: ValidationBuilder(requiredMessage: 'Vui lòng nhập điện thoại')
                          .phone('Số điện thoại không hợp lệ')
                          .build(),
                    ),
                    AppLevelActionContainer(
                      child: Row(
                        children: [
                          Checkbox(
                              value: controller.isDefault.value,
                              onChanged: (value) => controller.isDefault.value = value ?? false
                          ),
                          Expanded(
                            child: Text(
                              'Chọn làm địa chỉ mặc định',
                              style: theme.textTheme.subtitle1,
                            ),
                          )
                        ],
                      ),
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
      ),
    );
  }
}
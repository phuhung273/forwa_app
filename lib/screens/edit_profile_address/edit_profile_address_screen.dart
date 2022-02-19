import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/input_field.dart';
import 'package:forwa_app/widgets/keyboard_friendly_body.dart';
import 'package:forwa_app/widgets/text_field_container.dart';
import 'package:get/get.dart';

import 'edit_profile_address_screen_controller.dart';

class EditProfileAddressScreen extends GetView<EditProfileAddressController> {

  EditProfileAddressScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _districtKey = GlobalKey<FormFieldState>();
  final _wardKey = GlobalKey<FormFieldState>();

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
                    // TextFieldContainer(
                    //   child: DropdownButtonFormField(
                    //     hint: const Text('Thành phố/Tỉnh'),
                    //     isExpanded: true,
                    //     items: controller.cities.map((value) {
                    //       return DropdownMenuItem(
                    //         value: value,
                    //         child: Text(value),
                    //       );
                    //     }).toList(),
                    //     onChanged: (value) {
                    //       _districtKey.currentState?.reset();
                    //       controller.districtController.clear();
                    //       _wardKey.currentState?.reset();
                    //       controller.wardController.clear();
                    //       controller.city = value;
                    //     }
                    //   ),
                    // ),
                    // TextFieldContainer(
                    //   child: DropdownButtonFormField(
                    //     key: _districtKey,
                    //     hint: const Text('Quận/Huyện'),
                    //     isExpanded: true,
                    //     items: controller.districts.map((value) {
                    //       return DropdownMenuItem(
                    //         value: value,
                    //         child: Text(value),
                    //       );
                    //     }).toList(),
                    //     onChanged: (value) {
                    //       _wardKey.currentState?.reset();
                    //       controller.wardController.clear();
                    //       controller.district = value;
                    //     }
                    //   ),
                    // ),
                    // TextFieldContainer(
                    //   child: DropdownButtonFormField(
                    //     key: _wardKey,
                    //     hint: const Text('Phường/Xã'),
                    //     isExpanded: true,
                    //     items: controller.wards.map((value) {
                    //       return DropdownMenuItem(
                    //         value: value,
                    //         child: FittedBox(
                    //           child: Text(value)
                    //         ),
                    //       );
                    //     }).toList(),
                    //     onChanged: (value) => controller.ward = value
                    //   ),
                    // ),
                    // InputField(
                    //   hintText: 'Đường',
                    //   autofillHints: const [AutofillHints.streetAddressLevel1],
                    //   controller: controller.streetController,
                    //   textCapitalization: TextCapitalization.words,
                    //   validator: ValidationBuilder(requiredMessage: 'Ví dụ: 1 Lê Duẩn')
                    //       .build(),
                    // ),
                    InputField(
                      hintText: 'Địa chỉ',
                      controller: controller.addressController,
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
                    // InputField(
                    //   hintText: 'Điện thoại',
                    //   autofillHints: const [AutofillHints.telephoneNumber],
                    //   controller: controller.phoneController,
                    //   validator: ValidationBuilder(requiredMessage: 'Vui lòng nhập điện thoại')
                    //       .phone('Số điện thoại không hợp lệ')
                    //       .build(),
                    // ),
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
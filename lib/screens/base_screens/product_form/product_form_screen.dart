import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:forwa_app/helpers/time_helpers.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/address_select/address_select_screen_controller.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/body_with_persistent_bottom.dart';
import 'package:forwa_app/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../widgets/time_picker_input_field.dart';
import 'product_form_controller.dart';

abstract class ProductFormScreen<T extends ProductFormScreenController> extends GetView<T> {

  final AddressSelectScreenController _addressSelectController = Get.find();

  ProductFormScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  void _validate() {
    if (_formKey.currentState!.validate()) {
      controller.submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tải lên'
          ),
        ),
        body: BodyWithPersistentBottom(
            isKeyboard: isKeyboard,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Divider(),
                  buildImageGallery(),
                  InputField(
                    hintText: 'Tên đồ vật',
                    icon: Icons.card_giftcard,
                    controller: controller.nameController,
                    validator: ValidationBuilder(requiredMessage: 'Vui lòng nhập tên đồ vật')
                        .build(),
                  ),
                  InputField(
                    hintText: 'Mô tả đồ vật',
                    icon: Icons.edit,
                    controller: controller.descriptionController,
                    maxLines: 3,
                    validator: ValidationBuilder(requiredMessage: 'Vui lòng nhập mô tả')
                        .build(),
                  ),
                  const Divider(),
                  AppLevelActionContainer(
                    margin: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Text(
                          'Giờ có thể tới lấy',
                          style: theme.textTheme.subtitle1,
                        )
                      ],
                    )
                  ),
                  AppLevelActionContainer(
                    margin: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        Text(
                          'Từ (giờ)',
                          style: theme.textTheme.bodyText1,
                        )
                      ],
                    )
                  ),
                  AppLevelActionContainer(
                    child: Obx(
                      () => TimePickerInputField(
                        key: ValueKey(const Uuid().v4()),
                        onChange: (time) => controller.from.value = time!,
                        initialTime: stringToTimeOfDay(controller.from.value),
                      ),
                    ),
                  ),
                  AppLevelActionContainer(
                    margin: EdgeInsets.zero,
                    child: Row(
                      children: [
                        Text(
                          'Tới (giờ)',
                          style: theme.textTheme.bodyText1,
                        )
                      ],
                    )
                  ),
                  AppLevelActionContainer(
                    child: Obx(
                      () => TimePickerInputField(
                        key: ValueKey(const Uuid().v4()),
                        onChange: (time) => controller.to.value = time!,
                        initialTime: stringToTimeOfDay(controller.to.value),
                      ),
                    ),
                  ),
                  const Divider(),
                  AppLevelActionContainer(
                    child: Row(
                      children: [
                        Text(
                          'Địa chỉ lấy đồ',
                          style: theme.textTheme.subtitle1,
                        )
                      ],
                    )
                  ),
                  FutureBuilder<bool>(
                    future: _addressSelectController.fetchMyAddress(),
                    builder: (context, snapshot){
                      if(!snapshot.hasData){
                        return SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.secondary,
                            strokeWidth: 2.0,
                          ),
                        );
                      }

                      return const AppLevelActionContainer(
                          clipBehavior: Clip.none,
                          child: AddressDropdown()
                      );

                    }
                  ),
                  const Divider(),
                  AppLevelActionContainer(
                    child: ExpandablePanel(
                      theme: const ExpandableThemeData(
                        tapBodyToExpand: true,
                        tapBodyToCollapse: true,
                        hasIcon: true,
                      ),
                      header: Text(
                        'Thông tin thêm',
                        style: theme.textTheme.subtitle1,
                      ),
                      collapsed: const SizedBox(),
                      expanded: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildDueDateInput()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottom: AppLevelActionContainer(
              child: ElevatedButton(
                onPressed: _validate,
                child: const Text('Hoàn tất'),
              ),
            )
        ),
      ),
    );
  }

  Widget buildImageGallery();
  Widget buildDueDateInput();
}


class AddressDropdown extends GetView<AddressSelectScreenController> {
  const AddressDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
            () {
          if (controller.addresses.isEmpty) {
            return OutlinedButton.icon(
              label: const Text('Vui lòng thêm địa chỉ'),
              onPressed: () =>
                Get.toNamed(
                    ROUTE_CREATE_PROFILE_ADDRESS,
                    parameters: {
                      previousRouteParam: Get.currentRoute,
                    }
                ),
              icon: const Icon(Icons.add)
            );
          }

          final address = controller.addresses.firstWhere((element) => element.id == controller.id.value);

          final subtitle = '${address.name} ${address.phone}';

          return ListTile(
            onTap: () => Get.toNamed(ROUTE_SELECT_ADDRESS),
            isThreeLine: true,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                address.text!,
                style: theme.textTheme.bodyText1
              ),
            ),
            subtitle: Text(
              subtitle,
              style: theme.textTheme.bodyText1
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          );
        }
    );
  }
}
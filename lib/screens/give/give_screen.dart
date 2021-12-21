import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/address/address.dart';
import 'package:forwa_app/screens/base_controller/give_address_controller.dart';
import 'package:forwa_app/screens/edit_profile_address/edit_profile_address_screen_controller.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/body_with_persistent_bottom.dart';
import 'package:forwa_app/widgets/date_picker_input_field.dart';
import 'package:forwa_app/widgets/image_gallery_picker.dart';
import 'package:forwa_app/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:time_range/time_range.dart';

import '../../constants.dart';
import 'give_screen_controller.dart';

class GiveScreen extends GetView<GiveScreenController> {

  GiveScreen({Key? key}) : super(key: key);

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
          title: Text(
            'Tải lên',
            style: theme.textTheme.headline6
          ),
        ),
        body: BodyWithPersistentBottom(
          isKeyboard: isKeyboard,
          child: Form(
            key: _formKey,
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
                  validator: ValidationBuilder(requiredMessage: 'Vui lòng nhập tên đồ vật')
                      .build(),
                ),
                InputField(
                  hintText: 'Mô tả',
                  icon: Icons.edit,
                  controller: controller.descriptionController,
                  maxLines: 3,
                  validator: ValidationBuilder(requiredMessage: 'Vui lòng nhập mô tả')
                      .build(),
                ),
                // InputField(
                //   hintText: 'Giờ có thể lấy',
                //   icon: Icons.schedule,
                //   controller: controller.address1Controller,
                // ),
                const Divider(),
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
                ),
                const Divider(),
                FutureBuilder<bool>(
                  future: controller.fetchDefaultAddress(),
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
                        child: AddressExpandablePanel()
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
                        DatePickerInputField(
                          hintText: 'Ngày hết hạn',
                          icon: Icons.event,
                          onChange: (date) => controller.dueDate = date,
                        ),
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
              child: const Text('Gửi Lên'),
            ),
          )
        ),
      ),
    );
  }
}

class AddressExpandablePanel extends GetView<GiveAddressController> {
  const AddressExpandablePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () {
        if(controller.street.isEmpty){
          return TextButton.icon(
              label: const Text('Vui lòng thêm địa chỉ'),
              onPressed: () => Get.toNamed(
                  ROUTE_EDIT_PROFILE_ADDRESS,
                  parameters: {
                    previousRouteParam: Get.currentRoute,
                  }
              ),
              icon: const Icon(Icons.add)
          );
        }

        final header = '${controller.street} ${controller.ward} ${controller.district} ${controller.city}';

        return ExpandableNotifier(
          child: ScrollOnExpand(
            scrollOnExpand: true,
            scrollOnCollapse: false,
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                tapBodyToExpand: true,
                tapBodyToCollapse: true,
                hasIcon: true,
              ),
              header: Text(
                'Địa chỉ',
                style: theme.textTheme.subtitle1,
              ),
              collapsed: Text(
                header,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyText1,
              ),
              expanded: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding),
                    child: Text(
                      header,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style: theme.textTheme.bodyText1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding),
                    child: Text(
                      controller.city.value,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style: theme.textTheme.bodyText1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding),
                    child: Text(
                      controller.name.value,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style: theme.textTheme.bodyText1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding),
                    child: Text(
                      controller.phone.value,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style: theme.textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
              builder: (_, collapsed, expanded) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: defaultPadding,
                    right: defaultPadding,
                    bottom: defaultPadding,
                  ),
                  child: Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(crossFadePoint: 0),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}



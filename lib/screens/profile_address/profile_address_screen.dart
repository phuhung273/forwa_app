import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/address/address.dart';
import 'package:forwa_app/screens/profile_address_edit/profile_address_edit_screen_controller.dart';
import 'package:forwa_app/widgets/app_container.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:get/get.dart';

import 'profile_address_screen_controller.dart';

class ProfileAddressScreen extends GetView<ProfileAddressScreenController> {

  const ProfileAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý địa chỉ'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppContainer(
                child: Obx(
                  () => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.addresses.length,
                    itemBuilder: (context, index) => AddressCard(
                      address: controller.addresses[index],
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
              ),
              AppLevelActionContainer(
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(
                    ROUTE_CREATE_PROFILE_ADDRESS,
                    parameters: {
                      previousRouteParam: Get.currentRoute
                    }
                  ),
                  child: const Text('Thêm địa chỉ'),
                )
              )
            ],
          ),
        ),
      )
    );
  }
}

class AddressCard extends StatelessWidget {
  final Address address;
  const AddressCard({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final addressMark = address.isDefault == null || address.isDefault == false
        ? 'Địa chỉ phụ'
        : 'Địa chỉ mặc định';

    return ExpandableNotifier(
      child: ScrollOnExpand(
        scrollOnExpand: true,
        scrollOnCollapse: false,
        child: ExpandablePanel(
          theme: const ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            tapBodyToCollapse: true,
          ),
          header: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              addressMark,
              style: theme.textTheme.subtitle1,
            )
          ),
          collapsed: Text(
            address.text!,
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
                  address.text!,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  style: theme.textTheme.bodyText1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: defaultPadding),
                child: Text(
                  address.name!,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  style: theme.textTheme.bodyText1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: defaultPadding),
                child: Text(
                  address.phone!,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  style: theme.textTheme.bodyText1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: TextButton.icon(
                      onPressed: () => Get.toNamed(
                        ROUTE_EDIT_PROFILE_ADDRESS,
                        parameters: {
                          ProfileAddressEditScreenController.idParam: address.id!.toString(),
                          ProfileAddressEditScreenController.textParam: address.text!,
                          ProfileAddressEditScreenController.phoneParam: address.phone!,
                          ProfileAddressEditScreenController.defaultParam: address.isDefault.toString(),
                        }
                      ),
                      icon: const Icon(Icons.edit),
                      label: const Text('Sửa'),
                    ),
                  ),
                  Flexible(
                    child: TextButton.icon(
                      onPressed: () {
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text('Xóa'),
                    ),
                  ),
                ],
              )
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
  }
}

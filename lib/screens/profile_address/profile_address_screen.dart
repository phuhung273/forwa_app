import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/address/customer_address_response.dart';
import 'package:forwa_app/widgets/app_container.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:get/get.dart';

import 'profile_address_screen_controller.dart';

class ProfileAddressScreen extends GetView<ProfileAddressScreenController> {

  const ProfileAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý địa chỉ'),
        ),
        body: Column(
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
            if(controller.addresses.length < 2)
              AppLevelActionContainer(
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(ROUTE_EDIT_PROFILE_ADDRESS),
                  child: const Text('Thêm địa chỉ'),
                )
              )
          ],
        ),
      )
    );
  }
}

class AddressCard extends StatelessWidget {
  final CustomerAddressResponse address;
  const AddressCard({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addressMark = address.defaultBilling == null || address.defaultBilling == false
        ? 'Địa chỉ khác'
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
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText2,
              )),
          collapsed: Text(
            address.street.join(', '),
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          expanded: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: defaultPadding),
                child: Text(
                    address.street.join(', '),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: defaultPadding),
                child: Text(
                  address.city,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: defaultPadding),
                child: Text(
                  '${address.firstName} ${address.lastName}',
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: defaultPadding),
                child: Text(
                  address.telephone,
                  softWrap: true,
                  overflow: TextOverflow.fade,
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

  }
}

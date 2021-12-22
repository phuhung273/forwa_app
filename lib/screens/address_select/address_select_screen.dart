import 'package:flutter/material.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/edit_profile_address/edit_profile_address_screen_controller.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:get/get.dart';

import 'address_select_screen_controller.dart';

class AddressSelectScreen extends GetView<AddressSelectScreenController> {

  const AddressSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chọn địa chỉ',
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.addresses.length,
                  itemBuilder: (context, index) {
                    final address = controller.addresses[index];

                    final header = '${address.street} ${address.ward} ${address.district} ${address.city}';
                    final subtitle = '${address.name} ${address.phone}';

                    return CheckboxListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          header
                        ),
                      ),
                      subtitle: Text(
                        subtitle
                      ),
                      value: address.id == controller.id.value,
                      onChanged: (checked){
                        if(checked == true){
                          controller.selectAddress(index);
                        }
                      }
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                )
              ),
              const Divider(),
              AppLevelActionContainer(
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(
                    ROUTE_EDIT_PROFILE_ADDRESS,
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
import 'package:flutter/material.dart';
import 'package:forwa_app/di/analytics/analytic_service.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:get/get.dart';

import 'address_select_screen_controller.dart';

class AddressSelectScreen extends StatefulWidget {

  const AddressSelectScreen({Key? key}) : super(key: key);

  @override
  State<AddressSelectScreen> createState() => _AddressSelectScreenState();
}

class _AddressSelectScreenState extends State<AddressSelectScreen> {

  final AddressSelectScreenController _controller = Get.find();
  final AnalyticService _analyticService = Get.find();


  @override
  void initState() {
    super.initState();

    _analyticService.setCurrentScreen(ROUTE_SELECT_ADDRESS);
  }

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
                  itemCount: _controller.addresses.length,
                  itemBuilder: (context, index) {
                    final address = _controller.addresses[index];

                    final header = address.text;
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
                      value: address.id == _controller.id.value,
                      onChanged: (checked){
                        if(checked == true){
                          _controller.selectAddress(index);
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
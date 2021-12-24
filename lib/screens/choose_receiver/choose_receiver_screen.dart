import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/public_profile/public_profile_screen_controller.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';
import 'package:forwa_app/widgets/rating.dart';
import 'package:forwa_app/widgets/secondary_action_container.dart';
import 'package:get/get.dart';

import 'choose_receiver_screen_controller.dart';

class ChooseReceiverScreen extends GetView<ChooseReceiverScreenController> {

  const ChooseReceiverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chọn người nhận',
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.orders.length,
                  itemBuilder: (context, index) {
                    final order = controller.orders[index];

                    return ReceiverCard(
                      order: order,
                      onPick: () => controller.pickReceiver(order.id),
                      onSuccess: () => controller.orderToSuccess(index),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                ),
              ),
              const Divider(),
              AppLevelActionContainer(
                child: ElevatedButton(
                  onPressed: controller.productToSuccess,
                  child: const Text('Hoàn thành'),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ReceiverCard extends StatelessWidget {
  final Order order;
  final VoidCallback onPick;
  final VoidCallback onSuccess;
  const ReceiverCard({
    Key? key,
    required this.order,
    required this.onPick,
    required this.onSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = order.user!.name;
    final List<String> words = name.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24.0,
              backgroundColor: theme.colorScheme.secondary,
              child: Text(
                shortWords.map((e) => e[0]).join(),
                style: theme.textTheme.subtitle1!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: defaultPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.subtitle1,
                  ),
                  const Rating(score: 3, size: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      order.message,
                      style: theme.textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SecondaryActionContainer(
              child: OutlinedButton(
                onPressed: () =>
                  Get.toNamed(
                    ROUTE_PUBLIC_PROFILE,
                    parameters: {
                      userIdParam: order.userId.toString()
                    }
                  ),
                child: const Text('Xem thêm'),
              ),
            ),
            const SizedBox(width: defaultPadding),
            SecondaryActionContainer(
              child: _buildMainButton(order.statusType!),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildMainButton(OrderStatus status){
    if(status == OrderStatus.PROCESSING){
      return ElevatedButton(
        onPressed: onPick,
        child: Text(_buildMainButtonText(status)),
      );
    } else if(status == OrderStatus.SELECTED){
      return ElevatedButton(
        onPressed: onSuccess,
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
        ),
        child: Text(_buildMainButtonText(status)),
      );
    }

    return TextButton(
      onPressed: null,
      child: Text(_buildMainButtonText(status))
    );
  }

  _buildMainButtonText(OrderStatus status){
    switch(status){
      case OrderStatus.PROCESSING:
        return 'Chọn';
      case OrderStatus.SELECTED:
        return 'Đánh giá';
      case OrderStatus.FINISH:
        return 'Đã giao';
      default:
        return 'Chọn';
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/cart/cart_customer.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/widgets/rating.dart';
import 'package:forwa_app/widgets/secondary_action_container.dart';
import 'package:get/get.dart';

import 'choose_receiver_screen_controller.dart';

class ChooseReceiverScreen extends GetView<ChooseReceiverScreenController> {

  const ChooseReceiverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chọn người nhận'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Obx(
            () => ListView.separated(
              itemCount: controller.customers.length,
              itemBuilder: (context, index) {
                final customer = controller.customers[index];

                return ReceiverCard(
                  customer: customer,
                  onPick: () => controller.pickReceiver(customer.orderId),
                  onSuccess: () => controller.shipSuccess('${customer.customerFirstName} ${customer.customerLastName}'),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ),
      ),
    );
  }
}

class ReceiverCard extends StatelessWidget {
  final CartCustomer customer;
  final VoidCallback onPick;
  final VoidCallback onSuccess;
  const ReceiverCard({
    Key? key,
    required this.customer,
    required this.onPick,
    required this.onSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = customer.customerFirstName + customer.customerLastName;
    final List<String> words = name.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24.0,
              child: Text(
                shortWords.map((e) => e[0]).join(),
                style: theme.textTheme.headline5!.copyWith(
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
                    style: theme.textTheme.headline6,
                  ),
                  const Rating(score: 3),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      customer.customerNote ?? 'Không có lời nhắn',
                      style: theme.textTheme.bodyText2,
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
                onPressed: () => Get.toNamed(ROUTE_PUBLIC_PROFILE),
                child: const Text('Xem thêm'),
              ),
            ),
            const SizedBox(width: defaultPadding),
            SecondaryActionContainer(
              child: _buildMainButton(customer.status!),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildMainButton(OrderStatus status){
    if(status == OrderStatus.PENDING){
      return ElevatedButton(
        onPressed: onPick,
        child: Text(_buildMainButtonText(status)),
      );
    } else if(status == OrderStatus.PROCESSING){
      return ElevatedButton(
        onPressed: onSuccess,
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
      case OrderStatus.PENDING:
        return 'Chọn';
      case OrderStatus.PROCESSING:
        return 'Hoàn thành';
      case OrderStatus.SUCCESS:
        return 'Đã giao';
      default:
        return 'Chọn';
    }
  }
}

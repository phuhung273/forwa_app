import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/helpers/url_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/public_profile/public_profile_screen_controller.dart';
import 'package:forwa_app/screens/splash/splash_screen_controller.dart';
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

    return WillPopScope(
      onWillPop: () async {
        if(controller.isNotificationStart){
          Get.offAndToNamed(ROUTE_MAIN);
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
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
                  clipBehavior: Clip.none,
                  child: _buildMainButton()
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildMainButton(){
    return Obx(
      () {
        if(controller.finish.isFalse){
          return OutlinedButton(
            onPressed: controller.productToSuccess,
            child: const Text('Hoàn thành'),
          );
        }

        return const TextButton(
          onPressed: null,
          child: Text('Đã hoàn thành')
        );
      }
    );
  }
}

const AVATAR_SIZE = 24.0;

class ReceiverCard extends GetView<ChooseReceiverScreenController> {
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

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
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
                      userIdParam: order.userId.toString(),
                      notificationStartParam: controller.isNotificationStart ? NOTIFICATION_START_TRUE : ''
                    }
                  ),
                child: const Text('Xem thêm'),
              ),
            ),
            const SizedBox(width: defaultPadding),
            SecondaryActionContainer(
              child: _buildMainButton(order),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildAvatar(){
    final theme = Theme.of(Get.context!);
    final name = order.user!.name;
    final List<String> words = name.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    if(order.user?.imageUrl == null){
      return CircleAvatar(
        radius: AVATAR_SIZE,
        backgroundColor: theme.colorScheme.secondary,
        child: Text(
          shortWords.map((e) => e[0]).join(),
          style: theme.textTheme.subtitle1!.copyWith(
            color: Colors.white,
          ),
        ),
      );
    }

    return ExtendedImage.network(
      resolveUrl(order.user!.imageUrl!, HOST_URL),
      fit: BoxFit.cover,
      shape: BoxShape.circle,
      width: AVATAR_SIZE * 2,
      height: AVATAR_SIZE * 2,
    );
  }

  Widget _buildMainButton(Order item){
    final status = item.statusType!;

    if(status == OrderStatus.PROCESSING){
      return ElevatedButton(
        onPressed: onPick,
        child: const Text('Chọn'),
      );
    } else if(status == OrderStatus.SELECTED){

      if(item.sellerReviewId == null){
        return ElevatedButton(
          onPressed: onSuccess,
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
          child: const Text('Đánh giá'),
        );
      }

      return const TextButton(
        onPressed: null,
        child: Text('Đã đánh giá'),
      );
    }

    return const TextButton(
      onPressed: null,
      child: Text('')
    );
  }
}

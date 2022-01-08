import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/helpers/url_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/public_profile/public_profile_screen_controller.dart';
import 'package:forwa_app/widgets/app_container.dart';
import 'package:forwa_app/widgets/rating.dart';
import 'package:forwa_app/widgets/secondary_action_container.dart';
import 'package:get/get.dart';

import 'order_screen_controller.dart';

const IMAGE_WIDTH = 150.0;
const AVATAR_SIZE = 16.0;

class OrderScreen extends GetView<OrderScreenController> {

  const OrderScreen({Key? key}) : super(key: key);

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
            title: const Text('Tình trạng nhận'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                Obx(
                  () {
                    return Card(
                      shape: roundedRectangleShape,
                      elevation: 4.0,
                      child: Row(
                        children: [
                          Container(
                            height: IMAGE_WIDTH,
                            width: IMAGE_WIDTH,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius: roundedRectangleBorderRadius
                            ),
                            margin: const EdgeInsets.only(
                              right: 0.0,
                              left: 8.0,
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: controller.productImageUrl.isNotEmpty
                              ? ExtendedImage.network(
                                resolveUrl(controller.productImageUrl.value, HOST_URL),
                                width: IMAGE_WIDTH,
                                fit: BoxFit.cover,
                              )
                              : const SizedBox(),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 0.0,
                                  bottom: 4.0,
                                  right: 4.0,
                                  left: 12.0
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    minVerticalPadding: 0.0,
                                    minLeadingWidth: 0.0,
                                    horizontalTitleGap: 8.0,
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    onTap: () => Get.toNamed(
                                        ROUTE_PUBLIC_PROFILE,
                                        parameters: {
                                          userIdParam: controller.sellerId.string
                                        }
                                    ),
                                    leading: _buildAvatar(),
                                    title: Text(
                                      // shortWords.join(' '),
                                      controller.sellerName.value,
                                      style: theme.textTheme.bodyText1?.copyWith(
                                          fontWeight: FontWeight.w600
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Rating(score: 5, size: 12.0),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      controller.productName.value,
                                      style: theme.textTheme.bodyText1,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: StatusChip(),
                                  ),
                                  if(controller.status.value == OrderStatus.SELECTED && controller.buyerReviewId.value == 0)
                                    Center(
                                      child: SecondaryActionContainer(
                                          child: ElevatedButton.icon(
                                            icon: const Icon(Icons.textsms),
                                            onPressed: () {

                                            },
                                            label: const Text('Nhắn tin'),
                                          )
                                      ),
                                    ),
                                  if(controller.status.value == OrderStatus.SELECTED)
                                    _buildMainButton()
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Text(
                    'Các bước tiếp theo để nhận đồ',
                    style: theme.textTheme.subtitle1?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  )
                ),
                const PolicySection(),
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(){
    final theme = Theme.of(Get.context!);
    final name = controller.sellerName.value;
    final List<String> words = name.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    if(controller.userImageUrl.isEmpty){
      return CircleAvatar(
        radius: AVATAR_SIZE,
        backgroundColor: theme.colorScheme.secondary,
        child: Text(
          shortWords[0].isNotEmpty
            ? shortWords.map((e) => e[0]).join()
            : '',
          style: theme.textTheme.bodyText1!.copyWith(
            color: Colors.white,
          ),
        ),
      );
    }

    return ExtendedImage.network(
      resolveUrl(controller.userImageUrl.value, HOST_URL),
      fit: BoxFit.cover,
      shape: BoxShape.circle,
      width: AVATAR_SIZE * 2,
      height: AVATAR_SIZE * 2,
    );
  }

  Widget _buildMainButton(){
    if(controller.buyerReviewId.value == 0) {
      return Center(
        child: SecondaryActionContainer(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
            icon: const Icon(Icons.done),
            onPressed: controller.takeSuccess,
            label: const Text('Đánh giá'),
          )
        ),
      );
    }

    return const SizedBox();
  }
}

class PolicySection extends StatelessWidget {
  const PolicySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.grey[200]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPolicyRow(
              "1. Sau khi được chọn: tình trạng nhận sẽ chuyển sang 'Hãy tới lấy'",
              context
          ),
          _buildPolicyRow(
              '2. Lúc này, bạn có thể chat để chào hỏi người cho đồ và đến lấy.',
              context
          ),
          _buildPolicyRow(
              '3. Bạn có thể đánh giá trải nghiệm sau khi hoàn tất nữa.',
              context
          )
        ],
      ),
    );
  }

  Widget _buildPolicyRow(String text, context){
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
          top: 8.0
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w600
              ),
              // overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusChip extends GetView<OrderScreenController> {
  const StatusChip({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => Chip(
        backgroundColor: _buildColor(controller.status.value, controller.buyerReviewId.value),
        avatar: Icon(
          _buildIcon(controller.status.value, controller.buyerReviewId.value),
          color: Colors.white,
        ),
        label: Text(
          _buildMessage(controller.status.value, controller.buyerReviewId.value),
          style: theme.textTheme.bodyText1?.copyWith(
              color: Colors.white
          ),
        ),
      ),
    );
  }

  IconData _buildIcon(OrderStatus status, int buyerReviewId){
    switch(status){
      case OrderStatus.PROCESSING:
        return Icons.pending;
      case OrderStatus.SELECTED:
        if(buyerReviewId == 0){
          return Icons.pending;
        }
        return Icons.done;
      default:
        return Icons.pending;
    }
  }

  _buildColor(OrderStatus status, int buyerReviewId){
    switch(status){
      case OrderStatus.PROCESSING:
        return Colors.blueGrey;
      case OrderStatus.SELECTED:
        if(buyerReviewId == 0){
          return Colors.amber;
        }
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  _buildMessage(OrderStatus status, int buyerReviewId){
    switch(status){
      case OrderStatus.PROCESSING:
        return 'Chờ xác nhận';

      case OrderStatus.SELECTED:
        if(buyerReviewId == 0){
          return 'Hãy tới lấy';
        }
        return 'Đã đánh giá';

      default:
        return 'Chờ xác nhận';
    }
  }
}
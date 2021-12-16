import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:forwa_app/widgets/rating.dart';
import 'package:forwa_app/widgets/secondary_action_container.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'my_receivings_screen_controller.dart';

class MyReceivingsScreen extends StatelessWidget {

  final MyReceivingsScreenController _controller = Get.put(MyReceivingsScreenController());
  final MainScreenController _mainController = Get.find();

  MyReceivingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        _mainController.changeTab(HOME_SCREEN_INDEX);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: RefreshIndicator(
            color: theme.colorScheme.secondary,
            onRefresh: _controller.authorizedMain,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  floating: true,
                  leading: Container(
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: theme.colorScheme.secondary,
                      ),
                      iconSize: 20.0,
                      onPressed: () => _mainController.openDrawer(),
                    ),
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.textsms,
                          color: theme.colorScheme.secondary,
                        ),
                        iconSize: 20.0,
                        onPressed: () => _mainController.changeTab(CHAT_SCREEN_INDEX),
                      ),
                    )
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          'Danh sách nhận',
                          style: theme.textTheme.subtitle1,
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Obx(
                          () => ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _controller.orders.length,
                            itemBuilder: (context, index) =>
                                ReceivingCard(
                                  order: _controller.orders[index],
                                  onTakeSuccess: () => _controller.takeSuccess(index),
                                ),
                            separatorBuilder: (context, index) => const Divider(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ),
          ),
        )
      ),
    );
  }
}

const IMAGE_WIDTH = 150.0;

class ReceivingCard extends GetView<MyReceivingsScreenController> {
  final Order order;
  final VoidCallback onTakeSuccess;
  const ReceivingCard({
    Key? key,
    required this.order,
    required this.onTakeSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = order.product;
    final name = order.sellerName ?? 'Không tên';
    final List<String> words = name.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];
    final imageUrl = order.firstImageUrl;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
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
              child: ExtendedImage.network(
                '$HOST_URL$imageUrl',
                width: IMAGE_WIDTH,
                fit: BoxFit.cover,
              ),
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
                      leading: CircleAvatar(
                        radius: 16.0,
                        backgroundColor: theme.colorScheme.secondary,
                        child: Text(
                          shortWords.map((e) => e[0]).join(),
                          style: theme.textTheme.bodyText1!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(
                        // shortWords.join(' '),
                        name,
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
                        item!.name,
                        style: theme.textTheme.bodyText1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Cách ${_buildDistance()}km',
                        style: theme.textTheme.bodyText1?.copyWith(
                          color: theme.colorScheme.secondary
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: StatusChip(status: order.statusType!),
                    ),
                    if(order.statusType == OrderStatus.SELECTED)
                      Center(
                        child: SecondaryActionContainer(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.textsms),
                            onPressed: () { },
                            label: const Text('Nhắn tin'),
                          )
                        ),
                      ),
                    if(order.statusType == OrderStatus.SELECTED)
                      Center(
                        child: SecondaryActionContainer(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                            icon: const Icon(Icons.done),
                            onPressed: onTakeSuccess,
                            label: const Text('Hoàn thành'),
                          )
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _buildDistance() {
    final here = controller.here;
    return here != null && order.location != null
        ? (controller.distance.as(LengthUnit.Meter,
        LatLng(here.latitude!, here.longitude!), order.location!) / 1000)
        .toStringAsFixed(1)
        : '';
  }
}

class StatusChip extends StatelessWidget {
  final OrderStatus status;
  const StatusChip({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Chip(
      backgroundColor: _buildColor(status),
      avatar: Icon(
        _buildIcon(status),
        color: Colors.white,
      ),
      label: Text(
        _buildMessage(status),
        style: theme.textTheme.bodyText1?.copyWith(
            color: Colors.white
        ),
      ),
    );
  }

  IconData _buildIcon(OrderStatus status){
    switch(status){
      case OrderStatus.PROCESSING:
        return Icons.pending;
      case OrderStatus.SELECTED:
        return Icons.pending;
      case OrderStatus.FINISH:
        return Icons.done;
      case OrderStatus.CANCEL:
        return Icons.close;
      default:
        return Icons.pending;
    }
  }

  _buildColor(OrderStatus status){
    switch(status){
      case OrderStatus.PROCESSING:
        return Colors.blueGrey;
      case OrderStatus.SELECTED:
        return Colors.amber;
      case OrderStatus.FINISH:
        return Colors.green;
      case OrderStatus.CANCEL:
        return Colors.black;
      default:
        return Colors.blueGrey;
    }
  }

  _buildMessage(OrderStatus status){
    switch(status){
      case OrderStatus.PROCESSING:
        return 'Chờ xác nhận';
      case OrderStatus.SELECTED:
        return 'Hãy tới lấy';
      case OrderStatus.FINISH:
        return 'Đã nhận';
      case OrderStatus.CANCEL:
        return 'Đã hủy';
      default:
        return 'Chờ xác nhận';
    }
  }
}


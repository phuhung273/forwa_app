import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/helpers/url_helper.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/widgets/secondary_action_container.dart';
import 'package:get/get.dart';

import 'my_receivings_screen_controller.dart';

class MyReceivingsScreen extends StatelessWidget {

  final MyReceivingsScreenController _controller = Get.put(MyReceivingsScreenController());

  MyReceivingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          color: theme.colorScheme.secondary,
          onRefresh: _controller.authorizedMain,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              const SliverAppBar(
                automaticallyImplyLeading: false,
                title: Text('Danh Sách Nhận'),
              ),
              const SliverToBoxAdapter(
                child: Divider(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
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
              ),
            ]
          ),
        ),
      )
    );
  }
}

const IMAGE_WIDTH = 150.0;

class ReceivingCard extends StatelessWidget {
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
    final item = order.items.first;
    final name = order.sellerName ?? 'Không tên';
    final List<String> words = name.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];
    final imageUrl = order.firstImageUrl;

    return Row(
      children: [
        ExtendedImage.network(
          imageUrl != null
              ? resolveUrl(imageUrl)
              : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRMJzoA-zbaFtz6UF7qt9Be1d_601nNAoDTA&usqp=CAU',
          width: IMAGE_WIDTH,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  minVerticalPadding: 0.0,
                  minLeadingWidth: 0.0,
                  horizontalTitleGap: 8.0,
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    child: Text(
                      shortWords.map((e) => e[0]).join(),
                      style: theme.textTheme.headline6!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    shortWords.join(' '),
                    style: theme.textTheme.bodyText1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                  // subtitle: ,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Text(
                    item.name,
                    style: theme.textTheme.subtitle1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Khoảng cách: 3.5 km',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: StatusChip(status: order.statusType!),
                ),
                if(order.statusType == OrderStatus.PROCESSING)
                  Center(
                    child: SecondaryActionContainer(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.call),
                        onPressed: () { },
                        label: const Text('Gọi ngay'),
                      )
                    ),
                  ),
                if(order.statusType == OrderStatus.PROCESSING)
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
    );
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
      case OrderStatus.PENDING:
        return Icons.pending;
      case OrderStatus.PROCESSING:
        return Icons.pending;
      case OrderStatus.SUCCESS:
        return Icons.done;
      case OrderStatus.CANCELED:
        return Icons.close;
      default:
        return Icons.pending;
    }
  }

  _buildColor(OrderStatus status){
    switch(status){
      case OrderStatus.PENDING:
        return Colors.blueGrey;
      case OrderStatus.PROCESSING:
        return Colors.amber;
      case OrderStatus.SUCCESS:
        return Colors.green;
      case OrderStatus.CANCELED:
        return Colors.black;
      default:
        return Colors.blueGrey;
    }
  }

  _buildMessage(OrderStatus status){
    switch(status){
      case OrderStatus.PENDING:
        return 'Chờ xác nhận';
      case OrderStatus.PROCESSING:
        return 'Hãy tới lấy';
      case OrderStatus.SUCCESS:
        return 'Đã nhận';
      case OrderStatus.CANCELED:
        return 'Đã hủy';
      default:
        return 'Chờ xác nhận';
    }
  }
}


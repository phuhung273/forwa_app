import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/helpers/url_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/screens/components/appbar_chat_action.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:forwa_app/screens/message/message_screen_controller.dart';
import 'package:forwa_app/screens/public_profile/public_profile_screen_controller.dart';
import 'package:forwa_app/widgets/rating.dart';
import 'package:forwa_app/widgets/secondary_action_container.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'my_receivings_screen_controller.dart';

class MyReceivingsScreen extends StatefulWidget {

  const MyReceivingsScreen({Key? key}) : super(key: key);

  @override
  State<MyReceivingsScreen> createState() => _MyReceivingsScreenState();
}

class _MyReceivingsScreenState extends State<MyReceivingsScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final MyReceivingsScreenController _controller = Get.find();

  final MainScreenController _mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        _mainController.changeTab(HOME_SCREEN_INDEX);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
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
                  AppBarChatAction(),
                ],
              ),
              SliverFillRemaining(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                      ),
                      child: Text(
                        'Danh s??ch nh???n',
                        style: theme.textTheme.subtitle1?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: RefreshIndicator(
                          color: theme.colorScheme.secondary,
                          onRefresh: _controller.authorizedMain,
                          child: Obx(
                            () => ScrollablePositionedList.separated(
                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                              itemCount: _controller.orders.length,
                              itemPositionsListener: _controller.itemPositionsListener,
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
                    ),
                  ],
                ),
              ),
            ]
          ),
        )
      ),
    );
  }
}

const IMAGE_WIDTH = 150.0;
const AVATAR_SIZE = 16.0;

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
    final name = order.sellerName ?? 'Kh??ng t??n';
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
                resolveUrl(imageUrl!, HOST_URL),
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
                      onTap: () => PublicProfileScreenController.openScreen(order.product!.user!.id!),
                      leading: _buildAvatar(),
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
                        'C??ch ${_buildDistance()}km',
                        style: theme.textTheme.bodyText1?.copyWith(
                          color: theme.colorScheme.secondary
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: StatusChip(order: order),
                    ),
                    if(order.statusType != OrderStatus.PROCESSING && order.chatRoomId != null)
                      Center(
                        child: SecondaryActionContainer(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.textsms),
                            onPressed: () {
                              if(order.chatRoomId == null) return;
                              MessageScreenController.openScreenOnOtherScreen(order.chatRoomId!);
                            },
                            label: const Text('Nh???n tin'),
                          )
                        ),
                      ),
                    if(order.statusType != OrderStatus.PROCESSING)
                      _buildMainButton()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(){
    final theme = Theme.of(Get.context!);
    final name = order.sellerName ?? 'Kh??ng t??n';
    final List<String> words = name.split(' ');
    final List<String> shortWords = words.length > 1 ? [words.first, words.last] : [words.first];

    if(order.product?.user?.imageUrl == null){
      return CircleAvatar(
        radius: AVATAR_SIZE,
        backgroundColor: theme.colorScheme.secondary,
        child: Text(
          shortWords.map((e) => e[0]).join(),
          style: theme.textTheme.bodyText1!.copyWith(
            color: Colors.white,
          ),
        ),
      );
    }

    return ExtendedImage.network(
      resolveUrl(order.product!.user!.imageUrl!, HOST_URL),
      fit: BoxFit.cover,
      shape: BoxShape.circle,
      width: AVATAR_SIZE * 2,
      height: AVATAR_SIZE * 2,
    );
  }

  Widget _buildMainButton(){
    if(order.statusType == OrderStatus.SELECTED && order.buyerReviewId == null){
      return Center(
        child: SecondaryActionContainer(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              icon: const Icon(Icons.done),
              onPressed: onTakeSuccess,
              label: const Text('????nh gi??'),
            )
        ),
      );
    }

    return const SizedBox();
  }

  String _buildDistance() {
    final here = controller.here;
    return here != null && order.location != null
        ? (controller.distance.as(LengthUnit.Meter,
        LatLng(here.latitude, here.longitude), order.location!) / 1000)
        .toStringAsFixed(1)
        : '';
  }
}

class StatusChip extends StatelessWidget {
  final Order order;
  const StatusChip({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Chip(
      backgroundColor: _buildColor(order),
      avatar: Icon(
        _buildIcon(order),
        color: Colors.white,
      ),
      label: Text(
        _buildMessage(order),
        style: theme.textTheme.bodyText1?.copyWith(
            color: Colors.white
        ),
      ),
    );
  }

  IconData _buildIcon(Order item){
    final status = item.statusType;
    switch(status){
      case OrderStatus.PROCESSING:
        return Icons.pending;
      case OrderStatus.SELECTED:
        return Icons.done;
      default:
        return Icons.pending;
    }
  }

  _buildColor(Order item){
    final theme = Theme.of(Get.context!);
    final status = item.statusType;

    switch(status){
      case OrderStatus.PROCESSING:
        return Colors.blueGrey;
      case OrderStatus.SELECTED:
        return theme.colorScheme.secondary;
      default:
        return Colors.blueGrey;
    }
  }

  _buildMessage(Order item){
    final status = item.statusType;
    switch(status){
      case OrderStatus.PROCESSING:
        return 'Ch??? x??c nh???n';

      case OrderStatus.SELECTED:
        if(item.buyerReviewId != null){
          return '???? ????nh gi??';
        }
        return 'H??y t???i l???y';

      default:
        return 'Ch??? x??c nh???n';
    }
  }
}


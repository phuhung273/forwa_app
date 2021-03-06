import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/helpers/url_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/app_notification/app_notification.dart';
import 'package:forwa_app/screens/base_controller/app_notification_controller.dart';
import 'package:forwa_app/screens/choose_receiver/choose_receiver_screen_controller.dart';
import 'package:forwa_app/screens/components/appbar_chat_action.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:forwa_app/screens/notification/notification_screen_controller.dart';
import 'package:forwa_app/screens/order/order_screen_controller.dart';
import 'package:forwa_app/screens/product/product_screen_controller.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class NotificationScreen extends StatefulWidget {

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final _controller = Get.put(NotificationScreenController());

  final AppNotificationController _appNotificationController = Get.find();

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
                          'Th??ng b??o',
                          style: theme.textTheme.subtitle1?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                      const Divider(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: RefreshIndicator(
                            color: theme.colorScheme.secondary,
                            onRefresh: _controller.authorizedMain,
                            child: Obx(
                              () => ScrollablePositionedList.separated(
                                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                itemCount: _appNotificationController.notifications.length,
                                itemPositionsListener: _controller.itemPositionsListener,
                                itemBuilder: (context, index) {
                                  final item = _appNotificationController.notifications[index];
                                  return NotificationItem(notification: item);
                                },
                                separatorBuilder: (context, index) => const SizedBox(height: 12.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}

const IMAGE_SIZE = 80.0;

class NotificationItem extends StatelessWidget {
  final AppNotification notification;

  const NotificationItem({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        switch(notification.type){
          case AppNotificationType.processing:
            ChooseReceiverScreenController.openScreen(notification.product.id!);
            break;

          case AppNotificationType.selected:
            OrderScreenController.openScreen(notification.product.id!);
            break;

          case AppNotificationType.upload:
            ProductScreenController.openScreen(notification.product.id!);
            break;

          default:
            break;
        }
      },
      child: Row(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ExtendedImage.network(
              resolveUrl(notification.image.url, HOST_URL),
              width: IMAGE_SIZE,
              height: IMAGE_SIZE,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _buildMessage(notification),
                  style: theme.textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  _buildTime(notification),
                  style: theme.textTheme.bodyText1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String _buildMessage(AppNotification notification){
    switch(notification.type){
      case AppNotificationType.processing:
        return '???? c?? ng?????i xin ${notification.product.name} c???a b???n !';
      case AppNotificationType.selected:
        return 'B???n ???? ???????c ch???n. Mau t???i l???y ${notification.product.name}';
      case AppNotificationType.upload:
        return 'V???a c?? ng?????i ????ng ${notification.product.name} ??? g???n b???n';
      default:
        return '';
    }
  }

  String _buildTime(AppNotification notification){
    final now = DateTime.now();
    final resultDuration = now.difference(notification.createdAt);

    if(resultDuration.inHours < 1){
      return '${resultDuration.inMinutes} ph??t tr?????c';
    } if (resultDuration.inDays < 1) {
      return '${resultDuration.inHours} gi??? tr?????c';
    } else if (resultDuration.inDays < 30) {
      return '${resultDuration.inDays} ng??y tr?????c';
    }

    return '${(resultDuration.inDays/30).floor()} th??ng tr?????c';
  }
}

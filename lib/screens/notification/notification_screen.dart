import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/app_notification/app_notification.dart';
import 'package:forwa_app/screens/components/appbar_chat_action.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:forwa_app/screens/notification/notification_screen_controller.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {


  NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final _controller = Get.put(NotificationScreenController());

  final MainScreenController _mainController = Get.find();

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
                      AppBarChatAction(),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thông báo',
                            style: theme.textTheme.headline6,
                          ),
                          const Divider(),
                          Obx(
                            () => ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _controller.notifications.length,
                              itemBuilder: (context, index) {
                                final item = _controller.notifications[index];
                                return NotificationItem(notification: item);
                              },
                              separatorBuilder: (context, index) => const SizedBox(height: 12.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}

const IMAGE_SIZE = 80.0;

class NotificationItem extends GetView<NotificationScreenController> {
  final AppNotification notification;
  final MainScreenController _mainController = Get.find();

  NotificationItem({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        switch(notification.type){
          case AppNotificationType.PROCESSING:
            _mainController.changeTab(MY_GIVINGS_SCREEN_INDEX);
            break;
          case AppNotificationType.SELECTED:
            _mainController.changeTab(MY_RECEIVINGS_SCREEN_INDEX);
            break;
          case AppNotificationType.UPLOAD:
            break;
          case AppNotificationType.CANCEL:
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
              '$HOST_URL${notification.image.url}',
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
                  style: theme.textTheme.subtitle1,
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
      case AppNotificationType.PROCESSING:
        return 'Đã có người xin ${notification.product.name} của bạn !';
      case AppNotificationType.SELECTED:
        return 'Bạn đã được chọn. Mau tới lấy ${notification.product.name}';
      case AppNotificationType.UPLOAD:
        return '';
      case AppNotificationType.CANCEL:
        return '';
      default:
        return '';
    }
  }

  String _buildTime(AppNotification notification){
    final resultDuration = controller.now.difference(notification.createdAt);

    if(resultDuration.inHours < 1){
      return '${resultDuration.inMinutes} phút trước';
    } if (resultDuration.inDays < 1) {
      return '${resultDuration.inHours} giờ trước';
    } else if (resultDuration.inDays < 30) {
      return '${resultDuration.inDays} ngày trước';
    }

    return '${(resultDuration.inDays/30).floor()} tháng trước';
  }
}

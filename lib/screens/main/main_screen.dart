
import 'package:badges/badges.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/base_controller/app_notification_controller.dart';
import 'package:forwa_app/screens/chat/chat_screen.dart';
import 'package:forwa_app/screens/home/home_screen.dart';
import 'package:forwa_app/screens/my_givings/my_givings_creen.dart';
import 'package:forwa_app/screens/my_receivings/my_receivings_screen.dart';
import 'package:forwa_app/screens/notification/notification_screen.dart';
import 'package:forwa_app/screens/policy/policy_screen.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import 'main_screen_controller.dart';

const CHAT_SCREEN_INDEX = 4;
const HOME_SCREEN_INDEX = 0;
const MY_GIVINGS_SCREEN_INDEX = 1;
const MY_RECEIVINGS_SCREEN_INDEX = 2;
const NOTIFICATION_SCREEN_INDEX = 3;

class MainScreen extends StatefulWidget {

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.paused){
      // print('Im dead');
    }

    final lastState = WidgetsBinding.instance?.lifecycleState;
    if(lastState == AppLifecycleState.resumed){
      // print('Im alive');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const MainScreenView();
  }
}

class MainScreenView extends GetView<MainScreenController> {
  const MainScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AdvancedDrawer(
      backdropColor: theme.colorScheme.secondary,
      controller: controller.drawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: true,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: SafeArea(
        child: Scaffold(
          body: PageView(
            controller: controller.pageController,
            onPageChanged: controller.changeTab,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HomeScreen(),
              MyGivingsScreen(),
              MyReceivingsScreen(),
              NotificationScreen(),
              ChatScreen(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: controller.toGiveScreen,
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
          bottomNavigationBar: MyBottomNavigationBar(),
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}


class MyBottomNavigationBar extends GetView<MainScreenController> {

  final AppNotificationController _appNotificationController = Get.find();

  MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          _buildBottomNavigationCountItem(
            _appNotificationController.myGivingCount.string,
            Icons.volunteer_activism_outlined,
          ),
          _buildBottomNavigationCountItem(
            _appNotificationController.myReceivingCount.string,
            Icons.card_giftcard,
          ),
          _buildBottomNavigationCountItem(
            _appNotificationController.notificationCount.string,
            Icons.notifications_outlined,
          )
        ],
        currentIndex: controller.pageIndex.value > 3 ? 0 : controller.pageIndex.value,
        onTap: controller.changeTab,
        selectedItemColor: theme.colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 0),
        unselectedLabelStyle: const TextStyle(fontSize: 0),
      )
    );
  }

  _buildBottomNavigationCountItem(String count, IconData icon){
    final context = Get.context!;
    final theme = Theme.of(context);

    return BottomNavigationBarItem(
      icon: count != '0'
          ? Badge(
            badgeContent: Text(
              count,
              style: theme.textTheme.bodyText1?.copyWith(
                  color: theme.colorScheme.onSecondary
              ),
            ),
            animationType: BadgeAnimationType.scale,
            position: BadgePosition.topStart(
              top: -10,
              start: -20,
            ),
            child: Icon(icon)
          )
          : Icon(icon),
      label: '',
    );
  }
}

class MyDrawer extends GetView<MainScreenController> {
  MyDrawer({Key? key}) : super(key: key);

  final LocalStorage _localStorage = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: ListTileTheme(
        textColor: Colors.white,
        iconColor: Colors.white,
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: controller.avatar.isNotEmpty ? ExtendedImage.network(
                    controller.avatar.value,
                    fit: BoxFit.cover,
                  ): CircleAvatar(
                    backgroundColor: theme.colorScheme.surface,
                  ),
                ),
                Text(
                  controller.fullname.value,
                  style: theme.textTheme.subtitle1?.copyWith(
                    color: Colors.white,
                  ),
                ),
                ListTile(
                  onTap: () {
                    if(_localStorage.getAccessToken() == null){
                      Get.toNamed(ROUTE_LOGIN);
                    } else {
                      Get.toNamed(ROUTE_PROFILE);
                    }
                  },
                  leading: const Icon(Icons.account_circle_rounded),
                  title: const Text('Tài Khoản'),
                ),
                ListTile(
                  onTap: () => controller.changeTab(MY_GIVINGS_SCREEN_INDEX),
                  leading: const Icon(Icons.volunteer_activism),
                  title: const Text('Danh Sách Cho Đi'),
                ),
                ListTile(
                  onTap: () => controller.changeTab(MY_RECEIVINGS_SCREEN_INDEX),
                  leading: const Icon(Icons.card_giftcard),
                  title: const Text('Danh Sách Nhận'),
                ),
                ListTile(
                  onTap: () => controller.changeTab(CHAT_SCREEN_INDEX),
                  leading: const Icon(Icons.textsms),
                  title: const Text('Tin nhắn'),
                ),
                ListTile(
                  onTap: () => controller.changeTab(NOTIFICATION_SCREEN_INDEX),
                  leading: const Icon(Icons.notifications),
                  title: const Text('Thông Báo'),
                ),
                ListTile(
                  onTap: () => Get.toNamed(ROUTE_SUPPORT),
                  leading: const Icon(Icons.help),
                  title: const Text('Hỗ trợ'),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() =>
                      PolicyScreen(
                        onAgree: () => Get.back()
                      )
                    );
                  },
                  leading: const Icon(Icons.gavel),
                  title: const Text('Điều Khoản'),
                ),
                const SizedBox(height: defaultSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

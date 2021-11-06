import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:animations/animations.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/screens/home/home_screen.dart';
import 'package:forwa_app/screens/my_givings/my_givings_creen.dart';
import 'package:forwa_app/screens/my_receivings/my_receivings_screen.dart';
import 'package:get/get.dart';

import 'main_screen_controller.dart';

class MainScreen extends StatelessWidget {

  final MainScreenController _controller = Get.find();

  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AdvancedDrawer(
      backdropColor: Colors.blueGrey,
      controller: _controller.drawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: true,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Obx(
            () => PageTransitionSwitcher(
              transitionBuilder: (child, primaryAnimation, secondaryAnimation)=>
                  FadeThroughTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  ),
              child:  _buildTab(_controller.pageIndex.value),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(ROUTE_GIVE),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: MyBottomNavigationBar(),
      ),
      drawer: MyDrawer(),
    );
  }

  Widget _buildTab(int index){
    switch(index){
      case 0:
        return HomeScreen();

      case 1:
        return MyGivingsScreen();

      case 2:
        return MyReceivingsScreen();

      case 3:
        return HomeScreen();

      default:
        return HomeScreen();
    }
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  final MainScreenController _controller = Get.find();

  MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => AnimatedBottomNavigationBar(
        icons: const [
          Icons.home_outlined,
          Icons.volunteer_activism_outlined,
          Icons.card_giftcard,
          Icons.notifications_outlined,
        ],
        activeIndex: _controller.pageIndex.value,
        gapLocation: GapLocation.center,
        onTap: (index) => _controller.changeTab(index),
        backgroundColor: theme.primaryColor,
        activeColor: theme.colorScheme.secondaryVariant,
        inactiveColor: Colors.grey,
      )
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
          () => Column(
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
                title: const Text('Hồ Sơ'),
              ),
              ListTile(
                onTap: () { },
                leading: const Icon(Icons.volunteer_activism),
                title: const Text('Danh Sách Cho Đi'),
              ),
              ListTile(
                onTap: () { },
                leading: const Icon(Icons.card_giftcard),
                title: const Text('Danh Sách Nhận'),
              ),
              ListTile(
                onTap: () { },
                leading: const Icon(Icons.notifications),
                title: const Text('Thông Báo'),
              ),
              ListTile(
                onTap: () { },
                leading: const Icon(Icons.gavel),
                title: const Text('Điền Khoản'),
              ),
              ElevatedButton(
                onPressed: controller.logout,
                child: const Text('Đăng Xuất'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
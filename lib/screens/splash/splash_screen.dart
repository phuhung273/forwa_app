import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {

  final SplashScreenController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(
          child: Text('Forwa splash Screen'),
        ),
      ),
    );
  }
}
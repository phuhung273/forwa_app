import 'dart:async';

import 'package:get/get.dart';

class NavigationController extends GetxController {

  final _authController = StreamController<bool>.broadcast();
  final _tabController = StreamController<int>.broadcast();

  Stream get authStream => _authController.stream.cast<bool>();
  Stream get tabStream => _tabController.stream.cast<int>();

  void resetAuth(){
    _authController.sink.add(true);
  }

  void changeTab(int page){
    _tabController.sink.add(page);
  }
}
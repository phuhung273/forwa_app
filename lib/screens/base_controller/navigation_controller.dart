import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController with WidgetsBindingObserver {

  final LocalStorage _localStorage = Get.find();

  final _needReloadController = StreamController<bool>.broadcast();
  final _tabController = StreamController<int>.broadcast();

  Stream<bool> get reloadStream => _needReloadController.stream.cast<bool>();
  Stream<int> get tabStream => _tabController.stream.cast<int>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.paused){
      // print('Im dead');
    }

    final lastState = WidgetsBinding.instance?.lifecycleState;
    if(lastState == AppLifecycleState.resumed){
      // print('Im alive');
      if(_willReset()){
        reset();
      }
    }
  }

  /// Make all tabs reset on next open
  void reset(){
    _needReloadController.sink.add(true);
  }

  void changeTab(int page){
    _tabController.sink.add(page);
  }

  bool _willReset(){
    final now = DateTime.now();
    final lastOpenTime = _localStorage.getLastOpenTime();
    if(lastOpenTime == null){
      _localStorage.saveLastOpenTime(now);
      return false;
    }

    return now.difference(lastOpenTime).inDays > 0;
  }
}
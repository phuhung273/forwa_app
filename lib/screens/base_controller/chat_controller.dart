import 'dart:math';

import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/local/persistent_local_storage.dart';
import 'package:forwa_app/datasource/repository/chat_repo.dart';
import 'package:get/get.dart';

class ChatController extends GetxController with WidgetsBindingObserver {

  final PersistentLocalStorage _persistentLocalStorage = Get.find();

  final ChatRepo _chatRepo = Get.find();

  final unreadMessageCount = 0.obs;

  void increase(int value) => unreadMessageCount.value += value;

  void reset() => unreadMessageCount.value = 0;


  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.paused){
      // print('Im dead');
      _persistentLocalStorage.saveUnreadCount(unreadMessageCount.value);
    }

    final lastState = WidgetsBinding.instance?.lifecycleState;
    if(lastState == AppLifecycleState.resumed){
      // print('Im alive');
      unreadMessageCount.value = await _persistentLocalStorage.getUnreadCount() ?? 0;
    }
  }

  void fetchUnread(){
    _chatRepo.getUnread().then((response){
      if(!response.isSuccess || response.data == null){
        return;
      }

      increase(response.data?.count ?? 0);
    });
  }

  void decrease(int value) => unreadMessageCount.value = max(unreadMessageCount.value - value, 0);

  @override
  void dispose(){
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}


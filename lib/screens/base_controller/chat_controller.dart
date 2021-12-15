import 'dart:math';

import 'package:forwa_app/datasource/repository/chat_repo.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final ChatRepo _chatRepo = Get.find();

  final unreadMessageCount = 0.obs;

  void _increase(int value) => unreadMessageCount.value += value;

  void reset() => unreadMessageCount.value = 0;

  void fetch(){
    _chatRepo.getUnread().then((response){
      if(!response.isSuccess || response.data == null){
        return;
      }

      _increase(response.data?.count ?? 0);
    });
  }

  void decrease(int value) => unreadMessageCount.value = max(unreadMessageCount.value - value, 0);
}
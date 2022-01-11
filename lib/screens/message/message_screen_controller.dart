
import 'package:dash_chat/dash_chat.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/di/chat_service.dart';
import 'package:forwa_app/di/notification_service.dart';
import 'package:forwa_app/schema/chat/chat_room.dart';
import 'package:forwa_app/schema/chat/chat_socket_message.dart';
import 'package:forwa_app/schema/chat/lazy_show_request.dart';
import 'package:forwa_app/schema/chat/lazy_show_response.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/base_controller/chat_controller.dart';
import 'package:forwa_app/screens/chat/chat_screen_controller.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MessageScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageScreenController());
  }
}

class MessageScreenController extends BaseController with WidgetsBindingObserver {

  late ChatScreenController _chatScreenController;

  final Socket _socket = Get.find();

  final ChatController _chatController = Get.find();

  final LocalStorage _localStorage = Get.find();

  final destinationID = Get.arguments as String;

  final messages = List<ChatSocketMessage>.empty().obs;

  final roomName = ''.obs;

  int? _userId;
  bool isNotificationStart = false;
  bool isNotificationStartFromTerminated = false;
  bool _stopLazyLoad = false;

  late DateTime _earliest;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);
    _userId = _localStorage.getUserID();

    if(Get.parameters[notificationStartParam] == NOTIFICATION_START_TRUE){
      isNotificationStart = true;
      _setupNotificationStart();

      if(Get.parameters[notificationStartFromTerminatedParam] == NOTIFICATION_START_FROM_TERMINATED_TRUE){
        isNotificationStartFromTerminated = true;
      }
    } else {
      _setupNormal();
    }

    _chatController.messageStream.listen((event) {
      final chatSocketMessage = event as ChatSocketMessage;
      if(chatSocketMessage.roomId == destinationID){
        messages.add(chatSocketMessage);
      }
    });

  }

  _setupNormal(){
    _chatScreenController = Get.find();
    final room = _chatScreenController.roomMap[destinationID];
    if(room == null) return;

    final socketMessages = room.messages;

    roomName.value = _chatScreenController.roomMap[destinationID] != null
        ? _chatScreenController.roomMap[destinationID]!.name!
        : 'Tin nhắn';

    messages.assignAll(socketMessages);
    _calculateEarliest(messages);
  }

  _setupNotificationStart(){
    _socket.emitWithAck(CHANNEL_SHOW, { 'room': destinationID }, ack: (data) async {
      final room = ChatRoom.fromJson(data);
      room.name = room.users.firstWhere((element) => element.userID != _userId).username;
      roomName.value = room.name!;
      messages.assignAll(room.messages);
      _calculateEarliest(messages);
    });

    readMessage();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.paused){
      // print('Im dead');
      leaveMessage();
    }

    final lastState = WidgetsBinding.instance?.lifecycleState;
    if(lastState == AppLifecycleState.resumed){
      // print('Im alive');
      readMessage();
    }
  }

  void sendStringMessage(ChatMessage message){
    final socketMessage = ChatSocketMessage(
      content: message.text!,
      from: _userId!,
      roomId: destinationID,
      type: EnumToString.convertToString(MessageType.STRING)
    );
    _sendMessage(socketMessage);
  }

  void sendImageMessage(String base64Image){
    final socketMessage = ChatSocketMessage(
        content: base64Image,
        from: _userId!,
        roomId: destinationID,
        type: EnumToString.convertToString(MessageType.IMAGE)
    );
    _sendMessage(socketMessage);
  }

  _sendMessage(ChatSocketMessage message){
    _chatController.sendMessage(message, destinationID, (response){
      messages.add(response);

      if(!isNotificationStart){
        _chatScreenController.sendMessage(message, destinationID);
      }
    });
  }

  lazyLoad(){
    if(!_stopLazyLoad){
      final request = LazyShowRequest(
        roomId: destinationID,
        createdAt: _earliest
      );

      _socket.emitWithAck(CHANNEL_LAZY_SHOW, request, ack: (data) async {
        final response = LazyShowResponse.fromJson(data);
        messages.insertAll(0, response.messages);
        messages.refresh();
        _calculateEarliest(response.messages);
      });
    }
  }

  _calculateEarliest(List<ChatSocketMessage> messageList){
    _earliest = messageList[0].createdAt!;
    for (var element in messageList) {
      final createdAt = element.createdAt!;
      if(_earliest.compareTo(createdAt) <= 0){
        _earliest = createdAt;
      }
    }

    if(messageList.length < 15) _stopLazyLoad = true;
  }

  void leaveMessage(){
    _chatController.leaveMessage(destinationID);
  }

  void readMessage(){
    _chatController.readMessage(destinationID);
  }

  @override
  void onClose(){
    WidgetsBinding.instance?.removeObserver(this);
    super.onClose();
  }
}
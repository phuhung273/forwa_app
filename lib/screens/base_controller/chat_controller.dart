import 'dart:async';
import 'dart:math';


import 'package:flutter/material.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/local/persistent_local_storage.dart';
import 'package:forwa_app/datasource/repository/chat_repo.dart';
import 'package:forwa_app/di/chat_service.dart';
import 'package:forwa_app/schema/chat/chat_handshake_auth.dart';
import 'package:forwa_app/schema/chat/chat_room.dart';
import 'package:forwa_app/schema/chat/chat_session_response.dart';
import 'package:forwa_app/schema/chat/chat_socket_message.dart';
import 'package:forwa_app/schema/chat/leave_socket_message.dart';
import 'package:forwa_app/schema/chat/read_socket_message.dart';
import 'package:forwa_app/schema/chat/read_socket_message_response.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatController extends GetxController with WidgetsBindingObserver {

  final PersistentLocalStorage _persistentLocalStorage = Get.find();

  final ChatRepo _chatRepo = Get.find();

  final Socket _socket = Get.find();

  final LocalStorage _localStorage = Get.find();

  final unreadMessageCount = 0.obs;

  void increase(int value) => unreadMessageCount.value += value;

  void reset() => unreadMessageCount.value = 0;

  final StreamController _messageStreamController = StreamController<ChatSocketMessage>.broadcast();
  final StreamController _readMessageStreamController = StreamController<String>.broadcast();
  final StreamController _lazyMessageStreamController = StreamController<Map<String, List<ChatSocketMessage>>>.broadcast();
  final StreamController _roomStreamController = StreamController<ChatRoom>.broadcast();

  Stream get messageStream => _messageStreamController.stream.cast<ChatSocketMessage>();
  Stream get readMessageStream => _readMessageStreamController.stream.cast<String>();
  Stream get lazyMessageStream => _lazyMessageStreamController.stream.cast<Map<String, List<ChatSocketMessage>>>();
  Stream get roomStream => _roomStreamController.stream.cast<ChatRoom>();


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

  void init(){
    _socket.auth = ChatHandshakeAuth(
      username: _localStorage.getCustomerName()!,
      userID: _localStorage.getUserID()!,
      token: _localStorage.getAccessToken()!,
    ).toJson();

    _socket.close().clearListeners();
    _socket.connect();

    _socket.on(CHANNEL_SESSION, (sessionData){
      final sessionResponse = ChatSessionResponse.fromJson(sessionData as Map<String, dynamic>);

      _localStorage.saveChatSessionID(sessionResponse.sessionID);

    });

    _socket.on(CHANNEL_PRIVATE_MESSAGE, (data) async {
      final response = ChatSocketMessage.fromJson(data as Map<String, dynamic>);
      _messageStreamController.sink.add(response);
    });
  }

  void sendMessage(ChatSocketMessage message, String roomId) {
    _socket.emitWithAck(CHANNEL_PRIVATE_MESSAGE, message, ack: (data) {
      if(data != null){
        final response = ChatSocketMessage.fromJson(data as Map<String, dynamic>);
        _messageStreamController.sink.add(response);
      }
    });
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

  void leaveMessage(String roomId){
    final message = LeaveSocketMessage(roomId: roomId);
    _socket.emit(CHANNEL_LEAVE_MESSAGE, message);
  }

  void readMessage(String roomId){
    final message = ReadSocketMessage(roomId: roomId);
    _socket.emitWithAck(CHANNEL_READ_MESSAGE, message, ack: (data) {
      if(data != null){
        final response = ReadSocketMessageResponse.fromJson(data as Map<String, dynamic>);
        decrease(response.count);
        _readMessageStreamController.sink.add(roomId);
      }
    });
  }

  void addMessages(String roomId, List<ChatSocketMessage> messages){
    _lazyMessageStreamController.sink.add({ roomId: messages });
  }

  void addRoom(ChatRoom room){
    room.name = room.users.firstWhere((element) => element.userID != _localStorage.getUserID()).username;
    room.hasUnreadMessages = true;
    _roomStreamController.sink.add(room);
  }

  @override
  void onClose(){
    WidgetsBinding.instance?.removeObserver(this);
    _socket.dispose();
    super.onClose();
  }
}


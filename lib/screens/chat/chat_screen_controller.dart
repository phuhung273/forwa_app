
import 'package:dash_chat/dash_chat.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/di/chat_service.dart';
import 'package:forwa_app/mixins/lazy_load.dart';
import 'package:forwa_app/schema/chat/chat_room.dart';
import 'package:forwa_app/schema/chat/chat_room_list_response.dart';
import 'package:forwa_app/schema/chat/chat_socket_message.dart';
import 'package:forwa_app/schema/chat/chat_socket_user.dart';
import 'package:forwa_app/schema/chat/chat_user_disconnected_response.dart';
import 'package:forwa_app/schema/chat/lazy_room_request.dart';
import 'package:forwa_app/screens/base_controller/main_tab_controller.dart';
import 'package:forwa_app/screens/base_controller/chat_controller.dart';
import 'package:forwa_app/screens/main/main_screen.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatScreenController());
  }
}

class ChatScreenController extends MainTabController
  with LazyLoad {

  final Socket _socket = Get.find();

  final LocalStorage _localStorage = Get.find();

  final ChatController _chatController = Get.find();

  final roomMap = <String, ChatRoom>{}.obs;

  String? _username;
  int? userId;
  String? _token;

  @override
  int get pageIndex => CHAT_SCREEN_INDEX;

  @override
  int get listLength => roomMap.length;

  late DateTime _earliestUpdatedAt;

  @override
  void onInit(){
    super.onInit();
    _username = _localStorage.getCustomerName();
    userId = _localStorage.getUserID();
    _token = _localStorage.getAccessToken();
  }

  @override
  Future<bool> onReady() async {
    final result = await super.onReady();
    if(!result) return false;

    initLazyLoad();

    _socket.on(CHANNEL_USER_CONNECTED, (data){
      final response = ChatSocketUser.fromJson(data as Map<String, dynamic>);
      final rooms = roomMap.values;
      final relatedRooms = rooms.where((room) => room.users.any((user) => user.userID == response.userID));
      for (var element in relatedRooms) {
        roomMap[element.id]?.connected = 1;
      }
      roomMap.refresh();
    });

    _socket.on(CHANNEL_USER_DISCONNECTED, (data){
      final response = ChatUserDisconnectedResponse.fromJson(data as Map<String, dynamic>);
      final rooms = roomMap.values;
      final relatedRooms = rooms.where((room) => room.users.any((user) => user.userID == response.userID));

      for (var room in relatedRooms) {
        final index = room.users.indexWhere((element) => element.userID == response.userID);
        if(index > -1){
          room.users[index].connected = 0;
          room.connected = room.users.any((element) => element.connected == 1) ? 1 : 0;
          roomMap[room.id] = room;
        }
      }
      roomMap.refresh();
    });

    _listenPrivateMessageStream();
    _listenReadMessageStream();
    _listenLazyMessageStream();
    _listenRoomStream();

    return true;
  }

  @override
  Future main() async {
    _username = _localStorage.getCustomerName();
    userId = _localStorage.getUserID();
    _token = _localStorage.getAccessToken();
    roomMap.clear();

    showLoadingDialog();

    _socket.emitWithAck(CHANNEL_ROOMS, null, ack: (roomData) async {
      final roomResponse = ChatRoomListResponse.fromJson(roomData as Map<String, dynamic>);

      for(final room in roomResponse.rooms){
        room.users.removeWhere((element) => element.userID == userId);
        final roomName = room.users.firstWhere((element) => element.userID != userId).username;
        room.name = roomName;
        roomMap[room.id] = room;
      }

      if(roomResponse.rooms.length < 10){
        stopLazyLoad();
      } else {
        _calculateEdgeId();
        resetLazyLoad();
      }

      hideDialog();
    });
  }

  @override
  Future onLazyLoad() async {
    final request = LazyRoomRequest(updatedAt: _earliestUpdatedAt);

    _socket.emitWithAck(CHANNEL_LAZY_ROOMS, request, ack: (data){
      final response = ChatRoomListResponse.fromJson(data);
      final newItems = response.rooms;
      if(newItems.isEmpty){
        stopLazyLoad();
        return;
      }

      for (var element in newItems) {
        final roomName = element.users.firstWhere((element) => element.userID != _localStorage.getUserID()).username;
        element.name = roomName;
        roomMap[element.id] = element;
      }
      roomMap.refresh();
      _calculateEdgeId();
    });
  }

  _listenPrivateMessageStream(){
    _chatController.messageStream.listen((event) {
      final newMessage = ChatMessage(
        id: event.id,
        text: event.content,
        user: ChatUser(
          uid: event.from.toString(),
        ),
      );

      if(event.type == EnumToString.convertToString(MessageType.IMAGE)){
        newMessage.image = '$CHAT_PUBLIC_URL/${newMessage.text}';
        newMessage.text = '';
      } else if(event.type == EnumToString.convertToString(MessageType.LOCATION)){
        newMessage.image = '';
      }

      if(!event.readBy!.contains(userId!)){
        // Please keep this line here commented
        // This was commented not because of error
        // But because firebase messaging service has already handle the case
        // _chatController.increase(1);sid
        roomMap[event.roomId]?.hasUnreadMessages = true;
      }

      roomMap[event.roomId]?.messages.insert(0, event);
      roomMap.refresh();
    });
  }

  _listenReadMessageStream(){
    _chatController.readMessageStream.listen((event) {
      final room = roomMap[event];

      if(room != null){
        roomMap[event]?.hasUnreadMessages = false;
        roomMap.refresh();
      }
    });
  }

  _listenLazyMessageStream(){
    _chatController.lazyMessageStream.listen((event) {
      event.forEach((key, value) {
        if(roomMap.keys.contains(key)){
          roomMap[key]?.messages.addAll(value);
        }
      });
    });
  }

  _listenRoomStream(){
    _chatController.roomStream.listen((event) {
      if(roomMap.keys.contains(event.id)){
        // Room already exists
        final existTingRoom = roomMap[event.id]!;
        existTingRoom.hasUnreadMessages = true;
        final newRoomMap = { existTingRoom.id: existTingRoom };
        roomMap.remove(existTingRoom.id);
        newRoomMap.addAll(roomMap);
        roomMap.assignAll(newRoomMap);
        roomMap.refresh();
      } else {
        final newRoomMap = { event.id: event };
        newRoomMap.addAll(roomMap);
        roomMap.assignAll(newRoomMap);
        roomMap.refresh();
      }
    });
  }

  void _calculateEdgeId(){
    _earliestUpdatedAt = roomMap.values.first.updatedAt;
    for (var item in roomMap.values) {
      if(item.updatedAt.compareTo(_earliestUpdatedAt).isNegative){
        _earliestUpdatedAt = item.updatedAt;
      }
    }
  }

  @override
  void cleanData(){
    roomMap.clear();
  }

  @override
  bool isAuthorized() {
    _username = _localStorage.getCustomerName();
    userId = _localStorage.getUserID();
    _token = _localStorage.getAccessToken();
    return _username != null && userId != null || _token != null;
  }
}
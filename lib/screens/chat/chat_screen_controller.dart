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
import 'package:forwa_app/screens/base_controller/authorized_refreshable_controller.dart';
import 'package:forwa_app/screens/base_controller/chat_controller.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatScreenController());
  }
}

class ChatScreenController extends AuthorizedRefreshableController
  with LazyLoad {

  final Socket _socket = Get.find();

  final LocalStorage _localStorage = Get.find();

  final ChatController _chatController = Get.find();

  final roomMap = <String, ChatRoom>{}.obs;

  String? _username;
  int? userId;
  String? _token;

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
      final chatSocketMessage = event as ChatSocketMessage;
      final newMessage = ChatMessage(
        id: chatSocketMessage.id,
        text: chatSocketMessage.content,
        user: ChatUser(
          uid: chatSocketMessage.from.toString(),
        ),
      );

      if(chatSocketMessage.type == EnumToString.convertToString(MessageType.IMAGE)){
        newMessage.image = '$CHAT_PUBLIC_URL/${newMessage.text}';
        newMessage.text = '';
      } else if(chatSocketMessage.type == EnumToString.convertToString(MessageType.LOCATION)){
        newMessage.image = '';
      }

      if(!chatSocketMessage.readBy!.contains(userId!)){
        // Please keep this line here commented
        // This was commented not because of error
        // But because firebase messaging service has already handle the case
        // _chatController.increase(1);sid
        roomMap[chatSocketMessage.roomId]?.hasUnreadMessages = true;
      }

      roomMap[chatSocketMessage.roomId]?.messages.insert(0, chatSocketMessage);
      roomMap.refresh();
    });
  }

  _listenReadMessageStream(){
    _chatController.readMessageStream.listen((event) {
      final roomId = event as String;
      final room = roomMap[roomId];

      if(room != null){
        roomMap[roomId]?.hasUnreadMessages = false;
        roomMap.refresh();
      }
    });
  }

  _listenLazyMessageStream(){
    _chatController.lazyMessageStream.listen((event) {
      final messageMap = event as Map<String, List<ChatSocketMessage>>;
      messageMap.forEach((key, value) {
        if(roomMap.keys.contains(key)){
          roomMap[key]?.messages.addAll(value);
        }
      });
    });
  }

  _listenRoomStream(){
    _chatController.roomStream.listen((event) {
      final room = event as ChatRoom;
      if(roomMap.keys.contains(room.id)){
        // Room already exists
        final existTingRoom = roomMap[room.id]!;
        existTingRoom.hasUnreadMessages = true;
        final newRoomMap = { existTingRoom.id: existTingRoom };
        roomMap.remove(existTingRoom.id);
        newRoomMap.addAll(roomMap);
        roomMap.assignAll(newRoomMap);
        roomMap.refresh();
      } else {
        final newRoomMap = { room.id: room };
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
  bool isAuthorized() {
    return _username != null && userId != null || _token != null;
  }
}
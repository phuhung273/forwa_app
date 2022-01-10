import 'package:dash_chat/dash_chat.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/di/chat_service.dart';
import 'package:forwa_app/schema/chat/chat_handshake_auth.dart';
import 'package:forwa_app/schema/chat/chat_room.dart';
import 'package:forwa_app/schema/chat/chat_room_list_response.dart';
import 'package:forwa_app/schema/chat/chat_session_response.dart';
import 'package:forwa_app/schema/chat/chat_socket_message.dart';
import 'package:forwa_app/schema/chat/chat_socket_user.dart';
import 'package:forwa_app/schema/chat/chat_user_disconnected_response.dart';
import 'package:forwa_app/schema/chat/leave_socket_message.dart';
import 'package:forwa_app/schema/chat/read_socket_message.dart';
import 'package:forwa_app/schema/chat/read_socket_message_response.dart';
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

class ChatScreenController extends AuthorizedRefreshableController {
  final Socket _socket = Get.find();

  final LocalStorage _localStorage = Get.find();

  final ChatController _chatController = Get.find();

  final roomMap = <String, ChatRoom>{}.obs;

  String? _username;
  int? userId;
  String? _token;

  @override
  void onInit(){
    super.onInit();
    _username = _localStorage.getCustomerName();
    userId = _localStorage.getUserID();
    _token = _localStorage.getAccessToken();
  }

  @override
  Future main() async {

    showLoadingDialog();

    _socket.auth = ChatHandshakeAuth(
      username: _username!,
      userID: userId!,
      token: _token!,
    ).toJson();

    _socket.close().clearListeners();
    _socket.connect();

    _socket.on(CHANNEL_SESSION, (data){
      final response = ChatSessionResponse.fromJson(data as Map<String, dynamic>);

      _localStorage.saveChatSessionID(response.sessionID);
    });

    _socket.on(CHANNEL_ROOMS, (data) async {
      final response = ChatRoomListResponse.fromJson(data as Map<String, dynamic>);

      for(final room in response.rooms){
        final roomName = room.users.firstWhere((element) => element.userID != userId).username;
        room.name = roomName;
        roomMap[room.id] = room;
      }

      hideDialog();
    });

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
      print(data);
      final response = ChatUserDisconnectedResponse.fromJson(data as Map<String, dynamic>);
      final rooms = roomMap.values;
      final relatedRooms = rooms.where((room) => room.users.any((user) => user.userID == response.userID));

      for (var room in relatedRooms) {
        final index = room.users.indexWhere((element) => element.userID == response.userID);
        room.connected = 0;
        room.users[index].connected = 0;
        roomMap[room.id] = room;
      }
      roomMap.refresh();
    });

    _socket.on(CHANNEL_PRIVATE_MESSAGE, (data) async {
      final response = ChatSocketMessage.fromJson(data as Map<String, dynamic>);
      final newMessage = ChatMessage(
        id: response.id,
        text: response.content,
        user: ChatUser(
          uid: response.from.toString(),
        ),
      );

      if(response.type == EnumToString.convertToString(MessageType.IMAGE)){
        newMessage.image = '$CHAT_PUBLIC_URL/${newMessage.text}';
        newMessage.text = '';
      } else if(response.type == EnumToString.convertToString(MessageType.LOCATION)){
        newMessage.image = '';
      }

      if(!response.readBy!.contains(userId!)){
        // Please keep this line here commented
        // This was commented not because of error
        // But because firebase messaging service has already handle the case
        // _chatController.increase(1);sid
        roomMap[response.roomId]?.hasUnreadMessages = true;
      }

      roomMap[response.roomId]?.messages.add(response);
      roomMap.refresh();
    });

  }

  Future sendStringMessage(ChatMessage newMessage, String roomId) async {
    if(newMessage.text == null || newMessage.text!.isEmpty){
      return;
    }

    final newSocketMessage = ChatSocketMessage(
      content: newMessage.text!,
      from: _localStorage.getUserID()!,
      roomId: roomId,
      type: EnumToString.convertToString(MessageType.STRING),
    );

    _socket.emitWithAck(CHANNEL_PRIVATE_MESSAGE, newSocketMessage, ack: (data) {
      if(data != null){
        final response = ChatSocketMessage.fromJson(data as Map<String, dynamic>);

        _sendMessage(response, newMessage, roomId);
      }
    });

  }

  Future sendImageMessage(String base64Image, String roomId) async {
    final newSocketMessage = ChatSocketMessage(
      content: base64Image,
      from: _localStorage.getUserID()!,
      roomId: roomId,
      type: EnumToString.convertToString(MessageType.IMAGE),
    );

    _socket.emitWithAck(CHANNEL_PRIVATE_MESSAGE, newSocketMessage, ack: (data) {
      if(data != null){
        final response = ChatSocketMessage.fromJson(data as Map<String, dynamic>);
        final newMessage = ChatMessage(
          text: '',
          user: ChatUser(
            uid: newSocketMessage.from.toString()
          ),
          image: '$CHAT_PUBLIC_URL/${response.content}',
        );

        _sendMessage(response, newMessage, roomId);
      }
    });
  }

  Future _sendMessage(ChatSocketMessage socketMessage, ChatMessage chatMessage, String roomId) async {

      roomMap[roomId]?.messages.add(socketMessage);
      roomMap.refresh();
  }

  void readMessage(String roomId){
    final message = ReadSocketMessage(roomId: roomId);
    _socket.emitWithAck(CHANNEL_READ_MESSAGE, message, ack: (data) {
      if(data != null){
        final response = ReadSocketMessageResponse.fromJson(data as Map<String, dynamic>);
        _chatController.decrease(response.count);
      }
    });

    roomMap[roomId]?.hasUnreadMessages = false;
    roomMap.refresh();
  }

  void leaveMessage(String roomId){
    final message = LeaveSocketMessage(roomId: roomId);
    _socket.emit(CHANNEL_LEAVE_MESSAGE, message);
  }

  @override
  void onClose() {
    super.onClose();
    _socket.dispose();
  }

  @override
  bool isAuthorized() {
    return _username != null && userId != null || _token != null;
  }
}
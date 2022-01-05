import 'package:dash_chat/dash_chat.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/di/chat_service.dart';
import 'package:forwa_app/schema/chat/chat_handshake_auth.dart';
import 'package:forwa_app/schema/chat/chat_session_response.dart';
import 'package:forwa_app/schema/chat/chat_socket_message.dart';
import 'package:forwa_app/schema/chat/chat_socket_user.dart';
import 'package:forwa_app/schema/chat/chat_user_disconnected_response.dart';
import 'package:forwa_app/schema/chat/chat_user_list_response.dart';
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

  final users = <int, ChatSocketUser>{}.obs;

  String? _username;
  int? _userId;
  String? _token;

  @override
  void onInit(){
    super.onInit();
    _username = _localStorage.getCustomerName();
    _userId = _localStorage.getUserID();
    _token = _localStorage.getAccessToken();
  }

  @override
  Future main() async {

    showLoadingDialog();

    _socket.auth = ChatHandshakeAuth(
      username: _username!,
      userID: _userId!,
      token: _token!,
    ).toJson();

    _socket.close().clearListeners();
    _socket.connect();

    _socket.on(CHANNEL_SESSION, (data){
      final response = ChatSessionResponse.fromJson(data as Map<String, dynamic>);

      _localStorage.saveChatSessionID(response.sessionID);
    });

    _socket.on(CHANNEL_USERS, (data) async {
      final response = ChatUserListResponse.fromJson(data as Map<String, dynamic>);

      for(final user in response.users){
        users[user.userID] = user;
      }

      hideDialog();
    });

    _socket.on(CHANNEL_USER_CONNECTED, (data){
      final response = ChatSocketUser.fromJson(data as Map<String, dynamic>);
      users[response.userID]?.connected = 1;
      users.refresh();
    });

    _socket.on(CHANNEL_USER_DISCONNECTED, (data){
      final response = ChatUserDisconnectedResponse.fromJson(data as Map<String, dynamic>);
      users[response.userID]?.connected = 0;
      users.refresh();
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

      if(!response.readBy!.contains(_userId!)){
        // Please keep this line here commented
        // This was commented not because of error
        // But because firebase messaging service has already handle the case
        // _chatController.increase(1);sid
        users[response.from]?.hasUnreadMessages = true;
      }

      users[response.from]?.messages?.add(response);
      users.refresh();
    });

  }

  Future sendStringMessage(ChatMessage newMessage, int toID) async {
    if(newMessage.text == null || newMessage.text!.isEmpty){
      return;
    }

    final newSocketMessage = ChatSocketMessage(
      content: newMessage.text!,
      from: _localStorage.getUserID()!,
      to: toID,
      type: EnumToString.convertToString(MessageType.STRING),
    );

    _socket.emitWithAck(CHANNEL_PRIVATE_MESSAGE, newSocketMessage, ack: (data) {
      if(data != null){
        final response = ChatSocketMessage.fromJson(data as Map<String, dynamic>);

        _sendMessage(response, newMessage, toID);
      }
    });

  }

  Future sendImageMessage(String base64Image, int toID) async {
    final newSocketMessage = ChatSocketMessage(
      content: base64Image,
      from: _localStorage.getUserID()!,
      to: toID,
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

        _sendMessage(response, newMessage, toID);
      }
    });
  }

  Future _sendMessage(ChatSocketMessage socketMessage, ChatMessage chatMessage, int toId) async {

      users[toId]?.messages?.add(socketMessage);
      users.refresh();
  }

  void readMessage(int fromId){
    final message = ReadSocketMessage(fromId: fromId);
    _socket.emitWithAck(CHANNEL_READ_MESSAGE, message, ack: (data) {
      if(data != null){
        final response = ReadSocketMessageResponse.fromJson(data as Map<String, dynamic>);
        _chatController.decrease(response.count);
      }
    });

    users[fromId]?.hasUnreadMessages = false;
    users.refresh();
  }

  void leaveMessage(int fromId){
    final message = LeaveSocketMessage(fromId: fromId);
    _socket.emit(CHANNEL_LEAVE_MESSAGE, message);
  }

  @override
  void onClose() {
    super.onClose();
    _socket.dispose();
  }

  @override
  bool isAuthorized() {
    return _username != null && _userId != null || _token != null;
  }
}
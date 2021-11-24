import 'package:dash_chat/dash_chat.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/schema/chat/chat_handshake_auth.dart';
import 'package:forwa_app/schema/chat/chat_session_response.dart';
import 'package:forwa_app/schema/chat/chat_socket_message.dart';
import 'package:forwa_app/schema/chat/chat_socket_user.dart';
import 'package:forwa_app/schema/chat/chat_user_disconnected_response.dart';
import 'package:forwa_app/schema/chat/chat_user_list_response.dart';
import 'package:forwa_app/screens/base_controller/authorized_controller.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatScreenController());
  }
}

class ChatScreenController extends AuthorizedController {
  final Socket _socket = Get.find();

  final LocalStorage _localStorage = Get.find();

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
  Future onReady() async {
    super.onReady();

    _socket.auth = ChatHandshakeAuth(
      username: _username!,
      userID: _userId!,
      token: _token!,
    ).toJson();

    _socket.disconnect().connect();

    _socket.on('session', (data){
      final response = ChatSessionResponse.fromJson(data as Map<String, dynamic>);

      _localStorage.saveChatSessionID(response.sessionID);
    });

    _socket.on('users', (data) async {
      final response = ChatUserListResponse.fromJson(data as Map<String, dynamic>);

      for(final user in response.users){
        users[user.userID] = user;
      }

    });

    _socket.on('user connected', (data){
      final response = ChatSocketUser.fromJson(data as Map<String, dynamic>);
      users[response.userID]?.connected = 1;
      users.refresh();
    });

    _socket.on('user disconnected', (data){
      final response = ChatUserDisconnectedResponse.fromJson(data as Map<String, dynamic>);
      users[response.userID]?.connected = 0;
      users.refresh();
    });

    _socket.on('private message', (data) async {
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

    _socket.emitWithAck('private message', newSocketMessage, ack: (data) {
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

    _socket.emitWithAck('private message', newSocketMessage, ack: (data) {
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

  Future _sendMessage(ChatSocketMessage socketMessage, ChatMessage chatMessage, int toID) async {

      users[toID]?.messages?.add(socketMessage);
      users.refresh();
  }

  @override
  void onClose() {
    super.onClose();
    _socket.disconnect();
    _socket.dispose();
  }

  @override
  bool isAuthorized() {
    return _username != null && _userId != null || _token != null;
  }
}
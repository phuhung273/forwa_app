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

      hideDialog();
    });
  }

  @override
  Future onLazyLoad() async {

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

      roomMap[chatSocketMessage.roomId]?.messages.add(chatSocketMessage);
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

  void sendMessage(ChatSocketMessage message, String roomId) {
    roomMap[roomId]?.messages.add(message);
    roomMap.refresh();
  }

  @override
  bool isAuthorized() {
    return _username != null && userId != null || _token != null;
  }
}
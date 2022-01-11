import 'package:forwa_app/schema/chat/chat_socket_message.dart';
import 'package:forwa_app/schema/chat/chat_socket_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_room.g.dart';

@JsonSerializable()
class ChatRoom {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'members')
  List<ChatSocketUser> users;

  @JsonKey(name: 'connected')
  int connected;

  @JsonKey(name: 'messages')
  List<ChatSocketMessage> messages;

  @JsonKey(name: 'hasUnreadMessages')
  bool hasUnreadMessages;

  @JsonKey(name: 'name')
  String? name;

  ChatRoom({
    required this.id,
    required this.users,
    this.connected = 0,
    required this.messages,
    this.hasUnreadMessages = false,
    this.name,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);
}
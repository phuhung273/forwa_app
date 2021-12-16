import 'package:json_annotation/json_annotation.dart';
import 'chat_socket_message.dart';

part 'chat_socket_user.g.dart';

const FIELD_USERID = 'userID';
const FIELD_USERNAME = 'username';
const FIELD_CONNECTED = 'connected';
const FIELD_MESSAGES = 'messages';
const FIELD_HAS_UNREAD_MESSAGES = 'hasUnreadMessages';

@JsonSerializable()
class ChatSocketUser {

  @JsonKey(name: FIELD_USERID)
  int userID;

  @JsonKey(name: FIELD_USERNAME)
  String username;

  @JsonKey(name: FIELD_CONNECTED)
  int? connected;

  @JsonKey(name: FIELD_MESSAGES)
  List<ChatSocketMessage>? messages;

  @JsonKey(name: FIELD_HAS_UNREAD_MESSAGES)
  bool? hasUnreadMessages;

  ChatSocketUser({
    required this.userID,
    required this.username,
    this.connected,
    this.messages,
    this.hasUnreadMessages,
  });

  factory ChatSocketUser.fromJson(Map<String, dynamic> json) =>
      _$ChatSocketUserFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSocketUserToJson(this);


  Map<String, dynamic> toJsonWithoutMessages() => {
    FIELD_USERID: userID,
    FIELD_USERNAME: username,
    FIELD_CONNECTED: connected,
  };

}
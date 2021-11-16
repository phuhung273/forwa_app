import 'package:json_annotation/json_annotation.dart';

part 'chat_handshake_auth.g.dart';

@JsonSerializable()
class ChatHandshakeAuth {

  @JsonKey(name: 'username')
  String username;

  @JsonKey(name: 'userID')
  int userID;

  @JsonKey(name: 'sessionID')
  String? sessionID;

  @JsonKey(name: 'token')
  String token;

  ChatHandshakeAuth({
    required this.username,
    required this.userID,
    this.sessionID,
    required this.token,
  });

  factory ChatHandshakeAuth.fromJson(Map<String, dynamic> json) =>
      _$ChatHandshakeAuthFromJson(json);

  Map<String, dynamic> toJson() => _$ChatHandshakeAuthToJson(this);

}
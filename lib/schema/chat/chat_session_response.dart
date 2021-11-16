import 'package:json_annotation/json_annotation.dart';

part 'chat_session_response.g.dart';

@JsonSerializable()
class ChatSessionResponse {

  @JsonKey(name: 'sessionID')
  String sessionID;

  @JsonKey(name: 'userID')
  int userID;

  ChatSessionResponse({
    required this.sessionID,
    required this.userID,
  });

  factory ChatSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSessionResponseToJson(this);

}
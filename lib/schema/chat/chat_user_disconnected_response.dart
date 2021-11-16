import 'package:json_annotation/json_annotation.dart';

part 'chat_user_disconnected_response.g.dart';

@JsonSerializable()
class ChatUserDisconnectedResponse {

  @JsonKey(name: 'userID')
  int userID;

  ChatUserDisconnectedResponse({
    required this.userID,
  });

  factory ChatUserDisconnectedResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatUserDisconnectedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatUserDisconnectedResponseToJson(this);

}
import 'package:json_annotation/json_annotation.dart';

part 'chat_unread_response.g.dart';

@JsonSerializable()
class ChatUnreadResponse {

  @JsonKey(name: 'count')
  int count;

  ChatUnreadResponse({
    required this.count,
  });

  factory ChatUnreadResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatUnreadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatUnreadResponseToJson(this);

}
import 'package:forwa_app/schema/chat/chat_socket_message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lazy_show_response.g.dart';

@JsonSerializable()
class LazyShowResponse {

  @JsonKey(name: 'messages')
  List<ChatSocketMessage> messages;

  LazyShowResponse({
    required this.messages,
  });

  factory LazyShowResponse.fromJson(Map<String, dynamic> json) =>
      _$LazyShowResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LazyShowResponseToJson(this);

}
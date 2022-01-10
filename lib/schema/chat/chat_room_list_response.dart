import 'package:forwa_app/schema/chat/chat_room.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_room_list_response.g.dart';

@JsonSerializable()
class ChatRoomListResponse {

  @JsonKey(name: 'rooms')
  List<ChatRoom> rooms;

  ChatRoomListResponse({
    required this.rooms,
  });

  factory ChatRoomListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomListResponseToJson(this);

}
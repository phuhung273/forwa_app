import 'package:json_annotation/json_annotation.dart';

part 'lazy_room_request.g.dart';

@JsonSerializable()
class LazyRoomRequest {

  @JsonKey(name: 'updatedAt')
  DateTime updatedAt;

  LazyRoomRequest({
    required this.updatedAt,
  });

  factory LazyRoomRequest.fromJson(Map<String, dynamic> json) =>
      _$LazyRoomRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LazyRoomRequestToJson(this);

}
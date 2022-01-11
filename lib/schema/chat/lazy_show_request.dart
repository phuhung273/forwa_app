import 'package:json_annotation/json_annotation.dart';

part 'lazy_show_request.g.dart';

@JsonSerializable()
class LazyShowRequest {

  @JsonKey(name: 'room')
  String roomId;

  @JsonKey(name: 'createdAt')
  DateTime createdAt;

  LazyShowRequest({
    required this.roomId,
    required this.createdAt,
  });

  factory LazyShowRequest.fromJson(Map<String, dynamic> json) =>
      _$LazyShowRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LazyShowRequestToJson(this);

}
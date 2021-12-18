import 'package:forwa_app/schema/order/order.dart';
import 'package:forwa_app/schema/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'message')
  String message;

  @JsonKey(name: 'rating')
  int rating;

  @JsonKey(name: 'from_user')
  User? fromUser;

  @JsonKey(name: 'to_user_id')
  int? toUserId;

  @JsonKey(name: 'order_id')
  int? orderId;

  @JsonKey(name: 'order')
  Order? order;

  Review({
    this.id,
    required this.message,
    required this.rating,
    this.fromUser,
    this.toUserId,
    this.orderId,
    this.order,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);

  String? get firstImageUrl => order?.product?.images?.first.url;

  String? get productName => order?.product?.name;

}
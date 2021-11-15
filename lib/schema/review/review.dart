import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {

  @JsonKey(name: 'entity_id')
  int? id;

  @JsonKey(name: 'comment')
  String comment;

  @JsonKey(name: 'rating')
  int rating;

  @JsonKey(name: 'from_customer_id')
  int fromCustomerId;

  @JsonKey(name: 'from_customer_name')
  String? fromCustomerName;

  @JsonKey(name: 'to_customer_id')
  int toCustomerId;

  @JsonKey(name: 'product_id')
  int productId;

  @JsonKey(name: 'product_base_image_url')
  String? productBaseImageUrl;

  @JsonKey(name: 'product_name')
  String? productName;

  @JsonKey(name: 'product_sku')
  String? productSku;

  Review({
    this.id,
    required this.comment,
    required this.rating,
    required this.fromCustomerId,
    this.fromCustomerName,
    required this.toCustomerId,
    required this.productId,
    this.productName,
    this.productBaseImageUrl,
    this.productSku,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);

}
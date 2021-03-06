import 'package:json_annotation/json_annotation.dart';

part 'product_detail.g.dart';

@JsonSerializable()
class ProductDetail {

  @JsonKey(name: 'quantity')
  int quantity;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'pickup_time')
  String pickupTime;

  @JsonKey(name: 'due_date')
  String? dueDate;

  ProductDetail({
    required this.quantity,
    required this.description,
    required this.pickupTime,
    this.dueDate,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailToJson(this);

}
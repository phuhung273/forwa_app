import 'package:forwa_app/schema/address/customer_address_response.dart';
import 'package:forwa_app/schema/review/review.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'phone')
  String? phone;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'addresses')
  List<CustomerAddressResponse>? addresses;

  @JsonKey(name: 'reviews')
  List<Review>? reviews;

  @JsonKey(name: 'rating')
  double? rating;

  Customer({
    this.id,
    this.email,
    this.phone,
    required this.name,
    this.addresses,
    this.reviews,
    this.rating,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

}
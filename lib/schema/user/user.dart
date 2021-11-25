import 'package:forwa_app/schema/review/review.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'phone')
  String? phone;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'reviews')
  List<Review>? reviews;

  @JsonKey(name: 'rating')
  double? rating;

  User({
    this.id,
    this.email,
    this.phone,
    required this.name,
    this.reviews,
    this.rating,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}
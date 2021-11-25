
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'street')
  String street;

  @JsonKey(name: 'ward')
  String ward;

  @JsonKey(name: 'district')
  String district;

  @JsonKey(name: 'city')
  String city;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'phone')
  String phone;

  @JsonKey(name: 'default')
  bool? isDefault;

  @JsonKey(name: 'latitude')
  String latitude;

  @JsonKey(name: 'longitude')
  String longitude;

  Address({
    this.id,
    required this.street,
    required this.ward,
    required this.district,
    required this.city,
    required this.name,
    required this.phone,
    this.isDefault,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  LatLng get location {
    return LatLng(double.tryParse(latitude)!, double.tryParse(longitude)!);
  }
}
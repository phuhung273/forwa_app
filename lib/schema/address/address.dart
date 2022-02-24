
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'text')
  String text;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'phone')
  String? phone;

  @JsonKey(name: 'default')
  bool? isDefault;

  @JsonKey(name: 'latitude')
  String latitude;

  @JsonKey(name: 'longitude')
  String longitude;

  Address({
    this.id,
    required this.text,
    required this.name,
    this.phone,
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

import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'success')
  bool isSuccess;

  @JsonKey(name: 'status_code')
  String? statusCode;

  @JsonKey(name: 'data')
  T? data;

  ApiResponse({
    this.message,
    this.isSuccess = true,
    this.statusCode,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$ApiResponseToJson(this, toJsonT);

  factory ApiResponse.fromError({String error = 'Lỗi không xác định'}){
    return ApiResponse(
      isSuccess: false,
      message: error,
    );
  }
}
import 'dart:io';

import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/user/user.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../constants.dart';

part 'user_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/api/users')
abstract class UserService {
  factory UserService(Dio dio, {String baseUrl}) = _UserService;

  @GET('/{userId}')
  Future<ApiResponse<User>> userInfo(@Path('userId') int customerId);

  @POST('/me')
  @MultiPart()
  Future<ApiResponse<User>> updateMyProfileWithAvatar(
    @Part(name: 'image') File image,
    @Part(name: 'name') String name,
  );

  @POST('/me')
  @MultiPart()
  Future<ApiResponse<User>> updateMyProfile(
    @Part(name: 'name') String name,
  );
}
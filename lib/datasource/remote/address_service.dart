import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/address/address.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'address_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/api')
abstract class AddressService {
  factory AddressService(Dio dio, {String baseUrl}) = _AddressService;

  @POST('/addresses')
  Future<ApiResponse<Address>> storeAddress(@Body() Address address);

  @PUT('/addresses/{id}')
  Future<ApiResponse<Address>> updateAddress(@Path('id') int id, @Body() Address address);

  @GET('/address/me')
  Future<ApiResponse<List<Address>>> getMyAddresses();
}
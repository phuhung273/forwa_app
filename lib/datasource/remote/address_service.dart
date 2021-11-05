import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/address/create_address_request.dart';
import 'package:forwa_app/schema/address/customer_address_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'address_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/rest')
abstract class AddressService {
  factory AddressService(Dio dio, {String baseUrl}) = _AddressService;

  @POST('/V2/addresses')
  Future<CustomerAddressResponse> saveAddress(@Body() CreateAddressRequest request);
}
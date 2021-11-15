import 'package:forwa_app/schema/customer/customer.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../constants.dart';

part 'customer_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/rest')
abstract class CustomerService {
  factory CustomerService(Dio dio, {String baseUrl}) = _CustomerService;

  @GET('/V1/customers/me')
  Future<Customer> myInfo();

  @GET('/V2/customers/{customerId}')
  Future<Customer> customerInfo(@Path('customerId') int customerId);
}
import 'package:forwa_app/schema/order/list_order_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../constants.dart';

part 'order_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/rest')
abstract class OrderService {
  factory OrderService(Dio dio, {String baseUrl}) = _OrderService;

  @GET('/V2/orders')
  Future<ListOrderResponse> getOrdersOfCustomer(
    @Query('searchCriteria[filter_groups][0][filters][0][field]') String customerIdAttribute,
    @Query('searchCriteria[filter_groups][0][filters][0][value]') int customerId,
    @Query('searchCriteria[pageSize]') int pageSize,
    @Query('fields') String fields,
  );

  @POST('/V2/order/{orderId}/invoice')
  Future<String> createInvoice(
    @Path('orderId') int orderId,
  );
}
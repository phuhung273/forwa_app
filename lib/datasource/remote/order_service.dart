import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/order/create_order_request.dart';
import 'package:forwa_app/schema/order/order.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../constants.dart';

part 'order_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/api/orders')
abstract class OrderService {
  factory OrderService(Dio dio, {String baseUrl}) = _OrderService;

  @POST('/')
  Future<ApiResponse<Order>> createOrder(@Body() CreateOrderRequest request);

  @GET('/me/get')
  Future<ApiResponse<List<Order>>> getMyOrders();

  @POST('/status/{orderId}')
  Future<String> selectOrder(
    @Path('orderId') int orderId,
  );

  @GET('/product/{productId}')
  Future<ApiResponse<List<Order>>> getOrdersOfProductId(
    @Path('productId') int productId,
  );
}
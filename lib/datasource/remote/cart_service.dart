import 'package:forwa_app/schema/cart/add_cart_request.dart';
import 'package:forwa_app/schema/cart/list_cart_customers_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../constants.dart';

part 'cart_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/rest')
abstract class CartService {
  factory CartService(Dio dio, {String baseUrl}) = _CartService;

  @POST('/V2/carts/mine/items')
  Future<String> addToOrder(@Body() AddCartRequest request);

  @GET('/V2/carts/items')
  Future<ListCartCustomersResponse> getCustomersOfProduct(
    @Query('productId') int productId,
  );
}
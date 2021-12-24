
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/schema/product/product_list_request.dart';
import 'package:forwa_app/schema/product/product_list_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'product_service.g.dart';

@RestApi(baseUrl: '$HOST_URL/api')
abstract class ProductService {
  factory ProductService(Dio dio, {String baseUrl}) = _ProductService;

  @POST('/products/list')
  Future<ProductListResponse> getProducts(@Body() ProductListRequest request);

  // @POST('/products')
  // Future<Product> addProduct(@Body() AddProductRequest request);

  @GET('/products/{id}')
  Future<ApiResponse<Product>> getProduct(@Path('id') int id);

  @GET('/user/showMyGiving')
  Future<ProductListResponse> getMyProducts();

  @POST('/products/{id}/finish')
  Future<ApiResponse<Product>> finishProduct(@Path('id') int id);
}
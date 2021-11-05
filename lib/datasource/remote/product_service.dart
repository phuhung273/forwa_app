
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/schema/product/add_product_request.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/schema/product/product_list_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'product_service.g.dart';

const DEFAULT_WEBSITE_ID = 1;
const DEFAULT_STORE_ID = 1;

@RestApi(baseUrl: '$HOST_URL/rest')
abstract class ProductService {
  factory ProductService(Dio dio, {String baseUrl}) = _ProductService;

  @GET('/V2/products')
  Future<ProductListResponse> getProductsOnWebsite(
    @Query('searchCriteria[filter_groups][0][filters][0][field]') String websiteAttribute,
    @Query('searchCriteria[filter_groups][0][filters][0][value]') int websiteId,
    @Query('searchCriteria[filter_groups][0][filters][0][condition_type]') String conditionType,
    @Query('searchCriteria[pageSize]') int pageSize,
    @Query('fields') String fields,
    @Query('searchCriteria[sortOrders][0][field]') String sortField,
    @Query('searchCriteria[sortOrders][0][direction]') String sortDirection,
  );

  @POST('/V2/products')
  Future<Product> addProduct(@Body() AddProductRequest request);

  @GET('/V2/products/{sku}')
  Future<Product> getProduct(@Path('sku') String sku);
}
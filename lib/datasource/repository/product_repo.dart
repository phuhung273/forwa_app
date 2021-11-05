
import 'package:forwa_app/datasource/remote/product_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/product/add_product_request.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/schema/product/product_list_response.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class ProductRepo extends BaseRepo {
  final ProductService _service = Get.find();

  Future<ApiResponse<ProductListResponse>> getProductsOnWebsite(
    {
      int websiteId = DEFAULT_WEBSITE_ID,
      int pageSize = 10,
    }
  ) async {
    return _getProductsOnWebsite(
      websiteId: websiteId,
      pageSize: pageSize,
    ).then((value){
      return ApiResponse<ProductListResponse>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<ProductListResponse>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<ProductListResponse>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<ProductListResponse>.fromError(error: error);
      }
    });
  }


  Future<ApiResponse<Product>> getProduct(String sku) async {
    return _service.getProduct(sku).then((value){
      return ApiResponse<Product>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<Product>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<Product>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<Product>.fromError(error: error);
      }
    });
  }


  Future<ApiResponse<Product>> addProduct(AddProductRequest request) async {
    return _service.addProduct(request).then((value){
      return ApiResponse<Product>(data: value);
    }).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<Product>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          print(error);
          return ApiResponse<Product>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          print(error);
          return ApiResponse<Product>.fromError(error: error);
      }
    });
  }


  Future<ProductListResponse> _getProductsOnWebsite({
    websiteId = DEFAULT_WEBSITE_ID,
    pageSize = 10,
    fields = 'items[id,sku,name,created_at,extension_attributes,custom_attributes]',
    sortField = 'created_at',
    sortDirection = 'DESC',
  }) async {
    return _service.getProductsOnWebsite(
      'website_id',
      websiteId,
      'finset',
      pageSize,
      fields,
      sortField,
      sortDirection,
    );
  }
}
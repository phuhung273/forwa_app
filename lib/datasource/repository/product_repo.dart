
import 'dart:convert';

import 'package:forwa_app/constants.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/remote/product_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/product/product.dart';
import 'package:forwa_app/schema/product/product_add.dart';
import 'package:forwa_app/schema/product/product_list_request.dart';
import 'package:forwa_app/schema/product/product_list_response.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


const errorCodeMap = {
  'PRODUCT_001': 'Người dùng chưa có địa chỉ'
};

class ProductRepo extends BaseRepo {
  final ProductService _service = Get.find();

  final LocalStorage _localStorage = Get.find();

  Future<ApiResponse<ProductListResponse>> getProducts(ProductListRequest request) async {
    return _service.getProducts(request).then((value){
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

  Future<ApiResponse<Product>> getProduct(int id) async {
    return _service.getProduct(id).catchError((Object obj) {
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

  Future<ApiResponse<ProductListResponse>> getMyProducts({
    int pageSize = 10,
  }) async {
    return _service.getMyProducts().then((value){
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


  Future<ApiResponse<ProductListResponse>> addProduct(List<ProductAdd> products) async {
    final uri = Uri.parse('$HOST_URL/api/products');

    // Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', uri);

    for(var i = 0; i < products.length; i++){
      final product = products[i];

      final fieldPrefix = 'data[$i]'; // like data[0], data[1]
      imageUploadRequest.fields.addAll({
        '$fieldPrefix[sku]' : product.sku,
        '$fieldPrefix[name]' : product.name,
        '$fieldPrefix[quantity]' : product.quantity.toString(),
        '$fieldPrefix[description]' : product.description,
        '$fieldPrefix[pickup_time]' : product.pickupTime,
      });

      if(product.dueDate != null){
        imageUploadRequest.fields.addAll({
          '$fieldPrefix[due_date]' : product.dueDate!,
        });
      }

      for(var j = 0; j < product.images.length; j++){
        final image = product.images[j];
        final mimeTypeData = lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])!.split('/');

        // Attach the file in the request
        final file = await http.MultipartFile.fromPath('$fieldPrefix[image][$j]', image.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
        imageUploadRequest.files.add(file);
      }
    }

    // add headers if needed
    imageUploadRequest.headers.addAll({
      'Authorization': 'Bearer ${_localStorage.getAccessToken() ?? ''}',
      'Accept': 'application/json',
    });

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      // print('Response: ${response.body}');
      return ApiResponse<ProductListResponse>.fromJson(
        jsonDecode(response.body),
        (json) {
          final items = json as List<dynamic>;
          return ProductListResponse(
            items: items.map((e) => Product.fromJson(e)).toList()
          );
        }
      );
    } catch (error) {
      print(error);
      return ApiResponse<ProductListResponse>.fromError(error: error.toString());
    }
  }
}
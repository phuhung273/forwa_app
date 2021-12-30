
import 'package:flutter/foundation.dart';
import 'package:forwa_app/datasource/remote/address_service.dart';
import 'package:forwa_app/datasource/repository/base_repo.dart';
import 'package:forwa_app/schema/address/address.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class AddressRepo extends BaseRepo{

  final AddressService _service = Get.find();

  Future<ApiResponse<Address>> saveAddress(Address address) async {
    return _service.saveAddress(address).catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<Address>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<Address>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<Address>.fromError(error: error);
      }
    });
  }

  Future<ApiResponse<List<Address>>> getMyAddresses() async {
    return _service.getMyAddresses().catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if(res == null || res.statusCode == HttpStatus.internalServerError) return ApiResponse<List<Address>>.fromError();

          final data = getErrorData(res);
          final error = data['message'] ?? res.statusMessage;
          debugPrint(error);
          return ApiResponse<List<Address>>.fromError(error: data['message'] ?? 'Lỗi không xác định');
        default:
          final error = obj.toString();
          debugPrint(error);
          return ApiResponse<List<Address>>.fromError(error: error);
      }
    });
  }
}
import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/auth_repo.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/auth/refresh_token_request.dart';
import 'package:get/get.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenController());
  }
}

class SplashScreenController extends GetxController {

  final AuthRepo _authRepo = Get.find();

  final LocalStorage _localStorage = Get.find();

  @override
  void onReady() {
    super.onReady();
    _configureDevice();
    Future.microtask(() => _loadData());
  }

  Future<Timer> _loadData() async {
    final token = await FirebaseMessaging.instance.getToken();

    if(token != null) {
      debugPrint('Firebase token: $token');
      final oldToken = _localStorage.getFirebaseToken();
      if(token != oldToken){
        _localStorage.removeCredentials();
      }
      _localStorage.saveFirebaseToken(token);
    }

    if(_isEnoughInfo()){
      final request = RefreshTokenRequest(device: _localStorage.getDeviceName()!);
      final response = await _authRepo.refreshToken(request);

      if(response.isSuccess && response.data != null){
        _localStorage.saveAccessToken(response.data!.accessToken);
      } else {
        _localStorage.removeCredentials();
      }
    }
    return Timer(const Duration(seconds: 1), _onDoneLoading);
  }

  Future _onDoneLoading() async {
    Get.offAndToNamed(ROUTE_INTRODUCTION);
  }

  Future _configureDevice() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if(_localStorage.getDeviceName() == null){

      if(Platform.isIOS){
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        _localStorage.saveDeviceName(iosInfo.utsname.machine!);
      } else {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        _localStorage.saveDeviceName(androidInfo.model!);
      }
    }

  }

  bool _isEnoughInfo(){
    return _localStorage.getAccessToken() != null && _localStorage.getDeviceName() != null;
  }
}
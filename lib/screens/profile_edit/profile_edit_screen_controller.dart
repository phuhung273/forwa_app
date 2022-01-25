import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/datasource/local/local_storage.dart';
import 'package:forwa_app/datasource/repository/user_repo.dart';
import 'package:forwa_app/helpers/url_helper.dart';
import 'package:forwa_app/route/route.dart';
import 'package:forwa_app/schema/api_response.dart';
import 'package:forwa_app/schema/user/user.dart';
import 'package:forwa_app/screens/base_controller/base_controller.dart';
import 'package:forwa_app/screens/main/main_screen_controller.dart';
import 'package:forwa_app/screens/profile/profile_screen_controller.dart';
import 'package:get/get.dart';

class ProfileEditScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileEditScreenController());
  }
}

class ProfileEditScreenController extends BaseController {

  final LocalStorage _localStorage = Get.find();

  final UserRepo _userRepo = Get.find();

  final MainScreenController _mainController = Get.find();

  final ProfileScreenController _profileController = Get.find();

  final TextEditingController nameController = TextEditingController();

  final imageUrl = ''.obs;

  File? avatar;
  final useFileAvatar = false.obs;

  @override
  void onInit(){
    super.onInit();

    nameController.text = _localStorage.getCustomerName() ?? '';
    imageUrl.value = _localStorage.getAvatarUrl() ?? '';
  }

  Future submit() async {
    if(avatar == null && nameController.text == _localStorage.getCustomerName()){
      return;
    }

    showLoadingDialog();

    var response = ApiResponse<User>();

    if(avatar == null){
      response = await _userRepo.updateMyProfile(
        name: nameController.text,
      );
    } else if (avatar != null){
      response = await _userRepo.updateMyProfileWithAvatar(
        avatar: avatar!,
        name: nameController.text,
      );
    }

    if(!response.isSuccess || response.data == null){
      return;
    }

    hideDialog();

    final user = response.data!;
    if(avatar == null){
      _localStorage.saveCustomerName(user.name);
    } else if (avatar != null){
      _localStorage.saveCustomerName(user.name);
      _localStorage.saveAvatarUrl(resolveUrl(user.imageUrl!, HOST_URL));
    }

    await showSuccessDialog(message: 'Cập nhật hồ sơ thành công');

    _profileController.refreshCredential();
    _mainController.refreshCredential();

    Get.until((route) => route.settings.name == ROUTE_PROFILE);
  }

  setFileAvatar(File image){
    avatar = image;
    useFileAvatar.trigger(true);
  }
}
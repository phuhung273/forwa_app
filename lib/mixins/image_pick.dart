
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

const METHOD_GALLERY = 'gallery';
const METHOD_CAMERA = 'camera';

mixin ImagePick {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickAndCrop() async {
    final context = Get.context;
    if(context == null) return null;

    final result = await showModalActionSheet<String>(
      context: context,
      style: AdaptiveStyle.material,
      actions: [
        const SheetAction(
          icon: Icons.photo_camera,
          label: 'Chụp hình',
          key: METHOD_CAMERA,
        ),
        const SheetAction(
          icon: Icons.collections,
          label: 'Chọn từ thư viện',
          key: METHOD_GALLERY,
          isDefaultAction: true,
        ),
      ],
    );

    XFile? image;
    if(result == METHOD_GALLERY){
      image = await _picker.pickImage(source: ImageSource.gallery);
    } else if (result == METHOD_CAMERA){
      image = await _picker.pickImage(source: ImageSource.camera);
    }

    if(image == null) return null;

    final croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Cắt ảnh',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          aspectRatioLockDimensionSwapEnabled: true,
          aspectRatioPickerButtonHidden: true,
          rotateButtonsHidden: true,
          rotateClockwiseButtonHidden: true,
        )
    );

    if(croppedFile == null) return null;
    return croppedFile;
  }
}
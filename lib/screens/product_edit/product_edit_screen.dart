import 'package:flutter/material.dart';
import 'package:forwa_app/screens/base_screens/product_form/product_form_screen.dart';
import 'package:get/get.dart';

import '../../widgets/date_picker_input_field.dart';
import '../../widgets/image_gallery_picker.dart';
import 'product_edit_screen_controller.dart';

class ProductEditScreen extends ProductFormScreen<ProductEditScreenController> {

  ProductEditScreen({Key? key}) : super(key: key);

  @override
  Widget buildImageGallery() {
    return Obx(
      () => ImageGalleryPicker(
        onPick: controller.addImage,
        onDeleteFile: controller.deleteFileImage,
        onDeleteUrl: controller.deleteUrlImage,
        initialImageUrlList: controller.urls.toList(),
      ),
    );
  }

  @override
  Widget buildDueDateInput() {
    return Obx(
      () => DatePickerInputField(
        hintText: 'Ngày hết hạn',
        icon: Icons.event,
        onChange: (date) => controller.setDueDate(date!),
        initialDate: controller.dueDate.isNotEmpty ? DateTime.parse(controller.dueDate.value) : null,
      ),
    );
  }
}
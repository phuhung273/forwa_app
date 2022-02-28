

import 'package:flutter/material.dart';
import 'package:forwa_app/screens/base_screens/product_form/product_form_screen.dart';


import '../../widgets/date_picker_input_field.dart';
import '../../widgets/image_gallery_picker.dart';
import 'give_screen_controller.dart';

class GiveScreen extends ProductFormScreen<GiveScreenController> {

  GiveScreen({Key? key}) : super(key: key);

  @override
  Widget buildImageGallery() {
    return ImageGalleryPicker(
      onPick: controller.addImage,
      onDeleteFile: controller.deleteFileImage,
    );
  }

  @override
  Widget buildDueDateInput() {
    return DatePickerInputField(
      hintText: 'Ngày hết hạn',
      icon: Icons.event,
      onChange: (date) => controller.setDueDate(date!),
    );
  }



}




import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin Dialogable{

  Future<void> showErrorDialog(BuildContext context, String message) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel')
            )
          ],
        )
    );
  }
}

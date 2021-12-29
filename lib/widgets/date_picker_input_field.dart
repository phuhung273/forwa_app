import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'text_field_container.dart';

class DatePickerInputField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final Function(DateTime? date) onChange;

  DatePickerInputField({
    Key? key,
    this.hintText = 'Ngày',
    this.icon,
    required this.onChange,
  }) : super(key: key);

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final start = DateTime.now();
    final end = DateTime.utc(2030);

    return InkWell(
      onTap: () async {

        final result = await showDatePicker(
          context: context,
          builder: (context, child) {
            return Theme(
              data: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(
                  primary: theme.colorScheme.secondaryVariant,
                  onPrimary: theme.colorScheme.onSecondary,
                )
              ),
              child: child!,
            );
          },
          initialDate: start,
          firstDate: start,
          lastDate: end,
          helpText: 'Chọn ngày',
          cancelText: 'Hủy',
          confirmText: 'Chọn',
          errorFormatText: 'Ngày không hợp lệ',
          errorInvalidText: 'Ngày không hợp lệ',
          fieldLabelText: 'Nhập ngày',
        );

        if(result != null){
          controller.text = DateFormat('dd-MM-yyyy').format(result);
          onChange(result);
        }
      },
      child: TextFieldContainer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            icon: icon != null ? Icon(
              icon,
            ) : null,
            hintText: hintText,
          ),
          readOnly: true,
          enabled: false,
        )
      ),
    );
  }
}

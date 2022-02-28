import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'text_field_container.dart';

class DatePickerInputField extends StatefulWidget {
  final String hintText;
  final IconData? icon;
  final Function(DateTime? date) onChange;
  final DateTime? initialDate;

  const DatePickerInputField({
    Key? key,
    this.hintText = 'Ngày',
    this.icon,
    required this.onChange,
    this.initialDate,
  }) : super(key: key);

  @override
  State<DatePickerInputField> createState() => _DatePickerInputFieldState();
}

class _DatePickerInputFieldState extends State<DatePickerInputField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final init = widget.initialDate ?? DateTime.now();
    final start = DateTime.utc(2000);
    final end = DateTime.utc(2030);

    return InkWell(
      onTap: () async {

        final result = await showDatePicker(
          context: context,
          builder: (context, child) {
            return Theme(
              data: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(
                  primary: theme.colorScheme.secondaryContainer,
                  onPrimary: theme.colorScheme.onSecondary,
                )
              ),
              child: child!,
            );
          },
          initialDate: init,
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
          widget.onChange(result);
        }
      },
      child: TextFieldContainer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            icon: widget.icon != null ? Icon(
              widget.icon,
            ) : null,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: theme.textTheme.bodyText1!.fontSize!
            ),
          ),
          readOnly: true,
          enabled: false,
          style: theme.textTheme.bodyText1,
        )
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

import 'text_field_container.dart';

class DatePickerInputField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final Function(DateTime? date) onChange;

  const DatePickerInputField({
    Key? key,
    this.hintText = 'Ngày',
    this.icon,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final start = DateTime.now();
    final end = DateTime.utc(2030);

    return InkWell(
      onTap: () async {

        final result = await showDatePicker(
          context: context,
          initialDate: start,
          firstDate: start,
          lastDate: end,
        );

        onChange(result);
      },
      child: TextFieldContainer(
        child: TextFormField(
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

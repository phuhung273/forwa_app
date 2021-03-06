import 'package:flutter/material.dart';
import 'package:forwa_app/helpers/time_helpers.dart';

import 'text_field_container.dart';

class TimePickerInputField extends StatefulWidget {
  final String hintText;
  final IconData? icon;
  final Function(String? time) onChange;
  final TimeOfDay? initialTime;
  const TimePickerInputField({
    Key? key,
    this.hintText = 'Giờ',
    this.icon,
    required this.onChange,
    this.initialTime,
  }) : super(key: key);

  @override
  State<TimePickerInputField> createState() => _TimePickerInputFieldState();
}

class _TimePickerInputFieldState extends State<TimePickerInputField> {
  final controller = TextEditingController();


  @override
  void initState() {
    super.initState();

    controller.text = widget.initialTime != null ? timeOfDayToString(widget.initialTime!) : '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async {

        final result = await showTimePicker(
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
          helpText: 'Chọn giờ',
          cancelText: 'Hủy',
          confirmText: 'Chọn',
          hourLabelText: 'Giờ',
          minuteLabelText: 'Phút',
          errorInvalidText: 'Không hợp lệ',
          initialTime: widget.initialTime ?? TimeOfDay.now()
        );

        if(result != null){
          final time = timeOfDayToString(result);
          controller.text = time;
          widget.onChange(time);
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

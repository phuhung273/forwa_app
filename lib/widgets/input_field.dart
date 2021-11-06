import 'package:flutter/material.dart';

import 'text_field_container.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final int maxLines;
  final TextEditingController controller;
  final Iterable<String>? autofillHints;
  const InputField({
    Key? key,
    required this.hintText,
    this.icon,
    required this.controller,
    this.maxLines = 1,
    this.autofillHints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: theme.colorScheme.secondary,
        ),
      ),
      child: TextFieldContainer(
        child: TextField(
          controller: controller,
          autofillHints: autofillHints,
          decoration: InputDecoration(
            icon: icon != null ? Icon(
              icon,
            ) : null,
            hintText: hintText,
          ),
          maxLines: maxLines,
        ),
      ),
    );
  }
}

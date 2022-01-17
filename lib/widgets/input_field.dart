import 'package:flutter/material.dart';

import 'text_field_container.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final int maxLines;
  final TextEditingController controller;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;

  const InputField({
    Key? key,
    required this.hintText,
    this.icon,
    required this.controller,
    this.maxLines = 1,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.sentences,
    this.validator,
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
        child: TextFormField(
          controller: controller,
          autofillHints: autofillHints,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            icon: icon != null ? Icon(
              icon,
            ) : null,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: theme.textTheme.bodyText1!.fontSize!
            ),
          ),
          maxLines: maxLines,
          validator: validator,
          style: theme.textTheme.bodyText1,
        ),
      ),
    );
  }
}

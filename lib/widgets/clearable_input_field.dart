import 'package:flutter/material.dart';

import 'text_field_container.dart';

class ClearableInputField extends StatefulWidget {
  final String hintText;
  final IconData? icon;
  final int maxLines;
  final TextEditingController controller;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final VoidCallback onClear;

  const ClearableInputField({
    Key? key,
    required this.hintText,
    this.icon,
    required this.controller,
    this.maxLines = 1,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.sentences,
    this.validator,
    required this.onClear
  }) : super(key: key);

  @override
  State<ClearableInputField> createState() => _ClearableInputFieldState();
}

class _ClearableInputFieldState extends State<ClearableInputField> {

  bool _showClearIcon = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      final text = widget.controller.text;
      if(text.isNotEmpty){
        setState(() {
          _showClearIcon = true;
        });
      }
    });
  }

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
          controller: widget.controller,
          autofillHints: widget.autofillHints,
          textCapitalization: widget.textCapitalization,
          decoration: InputDecoration(
            icon: widget.icon != null ? Icon(
              widget.icon,
            ) : null,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: theme.textTheme.bodyText1!.fontSize!
            ),
            suffixIcon: _showClearIcon ? IconButton(
              onPressed: widget.onClear,
              icon: const Icon(
                Icons.cancel,
              )
            ) : null
          ),
          maxLines: widget.maxLines,
          validator: widget.validator,
          style: theme.textTheme.bodyText1,
        ),
      ),
    );
  }
}

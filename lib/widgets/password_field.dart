import 'package:flutter/material.dart';

import 'text_field_container.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  const PasswordField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _showPwd = false;

  void _togglePwd () {
    setState((){
      _showPwd = !_showPwd;
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
        child: TextField(
          obscureText: !_showPwd,
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: 'Password',
            icon: const Icon(
              Icons.lock,
            ),
            suffixIcon: GestureDetector(
              onTap: _togglePwd,
              child: Icon(
                _showPwd ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class KeyboardFriendlyBody extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const KeyboardFriendlyBody({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      padding: padding,
      child: Container(
        width: double.infinity,
        // height: size.height,
        constraints: BoxConstraints(
          minHeight: size.height,
        ),
        child: child,
      ),
    );
  }
}

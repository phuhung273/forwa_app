import 'package:flutter/material.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey[300],
      thickness: 8.0,
    );
  }
}

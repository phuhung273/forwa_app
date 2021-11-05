import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';

class BodyWithPersistentBottom extends StatelessWidget {
  final Widget bottom;
  final Widget child;
  final bool isKeyboard;
  const BodyWithPersistentBottom({
    Key? key,
    required this.child,
    required this.bottom,
    required this.isKeyboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                child,
                const SizedBox(
                  height: defaultSpacing * 3,
                )
              ],
            ),
          ),
        ),
        if(!isKeyboard)
          SizedBox(
            width: double.infinity,
            height: size.height,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: bottom
            ),
          )
      ],
    );
  }
}

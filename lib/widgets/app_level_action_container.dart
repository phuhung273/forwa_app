import 'package:flutter/cupertino.dart';

import '../constants.dart';

class AppLevelActionContainer extends StatelessWidget {
  final Widget child;
  final Clip clipBehavior;
  final EdgeInsetsGeometry? margin;
  const AppLevelActionContainer({
    Key? key,
    required this.child,
    this.clipBehavior = Clip.hardEdge,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8.0),
      width: size.width * 0.8,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
          borderRadius: roundedRectangleBorderRadius
      ),
      child: child,
    );
  }
}

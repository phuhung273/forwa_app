import 'package:flutter/cupertino.dart';
import 'package:forwa_app/constants.dart';

class AppContainer extends StatelessWidget {
  final Widget child;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;

  const AppContainer({
    Key? key,
    required this.child,
    this.decoration,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: defaultSpacing, vertical: 4.0),
      child: child,
    );
  }
}

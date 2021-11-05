import 'package:flutter/material.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({
    Key? key,
    required this.child,
    required this.tag,
    this.onTap,
    // required this.width,
  }) : super(key: key);

  final String tag;
  final VoidCallback? onTap;
  // final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: width,
      child: Hero(
        tag: tag,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: child,
          ),
        ),
      ),
    );
  }
}
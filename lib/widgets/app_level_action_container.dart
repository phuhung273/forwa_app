import 'package:flutter/cupertino.dart';

import '../constants.dart';

class AppLevelActionContainer extends StatelessWidget {
  final Widget child;
  const AppLevelActionContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: size.width * 0.8,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: roundedRectangleBorderRadius
      ),
      child: child,
    );
  }
}

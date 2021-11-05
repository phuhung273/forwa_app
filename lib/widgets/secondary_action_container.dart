import 'package:flutter/material.dart';

import '../constants.dart';

class SecondaryActionContainer extends StatelessWidget {
  final Widget child;
  const SecondaryActionContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: size.width * 0.4,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: thinRoundedRectangleBorderRadius
      ),
      child: Theme(
        data: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: thinRoundedRectangleShape,
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              primary: secondaryColor,
              onPrimary: Colors.white,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
                shape: thinRoundedRectangleShape,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                primary: secondaryColor,
                side: const BorderSide(
                  color: secondaryColor,
                )
            ),
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                primary: onSurfaceColor,
              )
          ),
        ),
        child: child
      ),
    );
  }
}

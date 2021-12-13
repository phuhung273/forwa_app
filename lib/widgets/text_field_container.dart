import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';
import 'package:forwa_app/widgets/app_level_action_container.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppLevelActionContainer(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
        ),
        child: child,
      ),
    );
  }
}

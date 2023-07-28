import 'package:flutter/material.dart';

import '../../main.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({Key? key, required this.fill}) : super(key: key);

  final double fill;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FractionallySizedBox(
          heightFactor: fill,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              color: isDarkMode
                  ? colorScheme.primary
                  : colorScheme.primary.withOpacity(0.65),
            ),
          ),
        ),
      ),
    );
  }
}

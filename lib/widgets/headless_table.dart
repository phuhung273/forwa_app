import 'package:flutter/material.dart';

import '../constants.dart';

class HeadlessTable extends StatelessWidget {
  final Map<String, String> data;
  final bool striped;
  final bool matchBackground;
  final Map<int, TableColumnWidth>? columnWidths;
  const HeadlessTable({
    Key? key,
    required this.data,
    this.striped = true,
    this.matchBackground = false,
    this.columnWidths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var index = 0;

    return Table(
      columnWidths: columnWidths,
      children: data.entries.map((e) {
        index++;
        return TableRow(
          decoration: BoxDecoration(
            color: _rowColor(context, index),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: matchBackground ? 0 : defaultPadding,
                // vertical: defaultPadding
                vertical: 8.0
              ),
              child: Text(
                e.key,
                style: theme.textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: matchBackground ? 0 : defaultPadding,
                  // vertical: defaultPadding
                  vertical: 8.0
              ),
              child: Text(
                e.value,
                style: theme.textTheme.bodyText1
              ),
            ),
          ]
        );
      }).toList(),
    );
  }

  _rowColor(BuildContext context, int index){
    // if(matchBackground) return Theme.of(context).scaffoldBackgroundColor;
    // if(!striped) return Colors.white;
    // return index % 2 == 0 ? Colors.white : Colors.grey[100];

    return Colors.grey[200];
  }
}

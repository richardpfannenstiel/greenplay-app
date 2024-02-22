import 'package:flutter/material.dart';
import 'package:greenplay/views/components/sheet_pill.dart';

class CustomSheet extends StatelessWidget {
  const CustomSheet({super.key, required this.childWidget});
  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [const SheetPill(), Container(child: childWidget)],
    );
  }
}

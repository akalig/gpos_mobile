import 'package:flutter/material.dart';
import '../dimensions.dart';

class LayoutDashboard extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;

  const LayoutDashboard({super.key, required this.mobileBody, required this.tabletBody});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < mobileWidth) {
          return mobileBody;
        } else {
          return tabletBody;
        }
      },
    );
  }
}

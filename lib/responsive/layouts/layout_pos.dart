import 'package:flutter/material.dart';
import '../dimensions.dart';

class LayoutPOS extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;

  const LayoutPOS({super.key, required this.mobileBody, required this.tabletBody});

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

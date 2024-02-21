import 'package:flutter/material.dart';
import 'package:gpos_mobile/responsive/layouts/layout_pos.dart';
import 'package:gpos_mobile/responsive/mobile_pages/mobile_pos.dart';
import 'package:gpos_mobile/responsive/tablet_pages/tablet_pos.dart';

class POSMain extends StatefulWidget {
  const POSMain({super.key});

  @override
  State<POSMain> createState() => _POSMainState();
}

class _POSMainState extends State<POSMain> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LayoutPOS(mobileBody: MobilePOS(), tabletBody: TabletPOS(),),
    );
  }
}

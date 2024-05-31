import 'package:flutter/material.dart';
import 'package:gpos_mobile/responsive/layouts/layout_settings.dart';
import 'package:gpos_mobile/responsive/mobile_pages/mobile_settings.dart';

import '../responsive/tablet_pages/tablet_settings.dart';

class SettingsMain extends StatefulWidget {
  const SettingsMain({super.key});

  @override
  State<SettingsMain> createState() => _SettingsMainState();
}

class _SettingsMainState extends State<SettingsMain> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LayoutSettings(mobileBody: MobileSettings(), tabletBody: TabletSettings(),),
    );
  }
}

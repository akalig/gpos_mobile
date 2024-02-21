import 'package:flutter/material.dart';
import 'package:gpos_mobile/responsive/mobile_pages/mobile_dashboard.dart';
import 'package:gpos_mobile/responsive/layouts/layout_dashboard.dart';
import 'package:gpos_mobile/responsive/tablet_pages/tablet_dashboard.dart';

class DashboardMain extends StatefulWidget {
  const DashboardMain({super.key});

  @override
  State<DashboardMain> createState() => _DashboardMainState();
}

class _DashboardMainState extends State<DashboardMain> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LayoutDashboard(mobileBody: MobileDashboard(), tabletBody: TabletDashboard(),),
    );
  }
}

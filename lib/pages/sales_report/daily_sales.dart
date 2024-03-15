import 'package:flutter/material.dart';
import 'package:gpos_mobile/responsive/layouts/product_maintenance/layout_product_details.dart';
import 'package:gpos_mobile/responsive/tablet_pages/sales_report/tablet_daily_sales.dart';

import '../../responsive/mobile_pages/sales_report/mobile_daily_sales.dart';

class DailySalesMain extends StatefulWidget {
  const DailySalesMain({super.key});

  @override
  State<DailySalesMain> createState() => _DailySalesMainState();
}

class _DailySalesMainState extends State<DailySalesMain> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LayoutProductDetails(mobileBody: MobileDailySales(), tabletBody: TabletDailySales(),),
    );
  }
}

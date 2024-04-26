import 'package:flutter/material.dart';
import 'package:gpos_mobile/responsive/layouts/sales_report/layout_sales_history.dart';
import 'package:gpos_mobile/responsive/mobile_pages/sales_report/mobile_sales_history.dart';
import 'package:gpos_mobile/responsive/tablet_pages/sales_report/tablet_sales_history.dart';

class SalesHistoryMain extends StatefulWidget {
  const SalesHistoryMain({super.key});

  @override
  State<SalesHistoryMain> createState() => _SalesHistoryMainState();
}

class _SalesHistoryMainState extends State<SalesHistoryMain> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LayoutSalesHistory(mobileBody: MobileSalesHistory(), tabletBody: TabletSalesHistory(),),
    );
  }
}

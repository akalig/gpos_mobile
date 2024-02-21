import 'package:flutter/material.dart';
import 'package:gpos_mobile/responsive/layouts/product_maintenance/layout_supplier_details.dart';
import 'package:gpos_mobile/responsive/mobile_pages/product_maintenance/mobile_supplier_details.dart';
import 'package:gpos_mobile/responsive/tablet_pages/product_maintenance/tablet_supplier_details.dart';

class SupplierDetailsMain extends StatefulWidget {
  const SupplierDetailsMain({super.key});

  @override
  State<SupplierDetailsMain> createState() => _SupplierDetailsMainState();
}

class _SupplierDetailsMainState extends State<SupplierDetailsMain> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LayoutSupplierDetails(mobileBody: MobileSupplierDetails(), tabletBody: TabletSupplierDetails(),),
    );
  }
}

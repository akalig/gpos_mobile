import 'package:flutter/material.dart';
import 'package:gpos_mobile/responsive/layouts/product_maintenance/layout_product_types.dart';
import 'package:gpos_mobile/responsive/mobile_pages/product_maintenance/mobile_product_types.dart';
import 'package:gpos_mobile/responsive/tablet_pages/product_maintenance/tablet_product_types.dart';

class ProductTypesMain extends StatefulWidget {
  const ProductTypesMain({super.key});

  @override
  State<ProductTypesMain> createState() => _ProductTypesState();
}

class _ProductTypesState extends State<ProductTypesMain> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LayoutProductTypes(mobileBody: MobileProductTypes(), tabletBody: TabletProductTypes(),),
    );
  }
}

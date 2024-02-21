import 'package:flutter/material.dart';
import 'package:gpos_mobile/responsive/layouts/product_maintenance/layout_product_details.dart';
import 'package:gpos_mobile/responsive/mobile_pages/product_maintenance/mobile_product_details.dart';
import 'package:gpos_mobile/responsive/tablet_pages/product_maintenance/tablet_product_details.dart';

class ProductDetailsMain extends StatefulWidget {
  const ProductDetailsMain({super.key});

  @override
  State<ProductDetailsMain> createState() => _ProductDetailsMainState();
}

class _ProductDetailsMainState extends State<ProductDetailsMain> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LayoutProductDetails(mobileBody: MobileProductDetails(), tabletBody: TabletProductDetails(),),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gpos_mobile/pages/dashboard_main.dart';
import 'package:gpos_mobile/pages/pos_main.dart';
import 'package:gpos_mobile/pages/product_maintenance/product_details_main.dart';
import 'package:gpos_mobile/pages/product_maintenance/product_types_main.dart';

import '../pages/product_maintenance/supplier_details_main.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.zero,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'POS',
              style: TextStyle(fontSize: 14, letterSpacing: 2),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const POSMain()), // Replace with your actual Home widget
              );
            },
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text(
              'Dashboard',
              style: TextStyle(fontSize: 14, letterSpacing: 2),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const DashboardMain()), // Replace with your actual Home widget
              );
            },
          ),
          const SizedBox(height: 20),
          ExpansionTile(
            title: const Text(
              'Product Maintenance',
              style: TextStyle(fontSize: 14, letterSpacing: 2),
            ),
            children: [
              ListTile(
                title: const Text('Product Details'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const ProductDetailsMain()), // Replace with your actual Home widget
                  );
                },
              ),
              ListTile(
                title: const Text('Supplier Details'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const SupplierDetailsMain()), // Replace with your actual Home widget
                  );
                },
              ),
              ListTile(
                title: const Text('Product Types'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const ProductTypesMain()), // Replace with your actual Home widget
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ExpansionTile(
            title: const Text(
              'Sales Reports',
              style: TextStyle(fontSize: 14, letterSpacing: 2),
            ),
            children: [
              ListTile(
                title: const Text('Daily Sales'),
                onTap: () {
                  // Handle daily sales tap
                },
              ),
              ListTile(
                title: const Text('Sales History'),
                onTap: () {
                  // Handle sales history tap
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ExpansionTile(
            title: const Text(
              'Discount Maintenance',
              style: TextStyle(fontSize: 14, letterSpacing: 2),
            ),
            children: [
              ListTile(
                title: const Text('Senior Discount'),
                onTap: () {
                  // Handle senior discount tap
                },
              ),
              ListTile(
                title: const Text('PWD Discount'),
                onTap: () {
                  // Handle pwd discount tap
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text(
              'Settings',
              style: TextStyle(fontSize: 14, letterSpacing: 2),
            ),
            onTap: () {
              // Handle settings tap
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gpos_mobile/pages/dashboard_main.dart';
import 'package:gpos_mobile/pages/pos_main.dart';
import 'package:gpos_mobile/pages/product_maintenance/product_details_main.dart';
import 'package:gpos_mobile/pages/product_maintenance/product_types_main.dart';
import 'package:gpos_mobile/pages/sales_report/daily_sales.dart';
import 'package:gpos_mobile/pages/sales_report/sales_history.dart';

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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const DailySalesMain()), // Replace with your actual Home widget
                  );
                },
              ),
              ListTile(
                title: const Text('Sales History'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const SalesHistoryMain()), // Replace with your actual Home widget
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ExpansionTile(
            title: const Text(
              'User Maintenance',
              style: TextStyle(fontSize: 14, letterSpacing: 2),
            ),
            children: [
              ListTile(
                title: const Text('User Details'),
                onTap: () {

                },
              ),
              ListTile(
                title: const Text('User Transactions'),
                onTap: () {

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

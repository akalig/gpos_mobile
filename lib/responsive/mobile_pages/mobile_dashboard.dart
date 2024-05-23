import 'package:flutter/material.dart';
import '../../charts/pie_chart/mobile.dart';
import '../../sidebar_menu/sidebar_menu.dart';
import '../../database/database_helper.dart';
import 'package:intl/intl.dart';

class MobileDashboard extends StatefulWidget {
  const MobileDashboard({Key? key}) : super(key: key);

  @override
  _MobileDashboardState createState() => _MobileDashboardState();
}

class _MobileDashboardState extends State<MobileDashboard> {
  List<Map<String, dynamic>> _dailySalesData = [];
  bool _isLoading = true;

  void _refreshDailySalesAndTransactionData() async {
    final data = await SQLHelper.getDailySalesAndTransactionData();
    setState(() {
      _dailySalesData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshDailySalesAndTransactionData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('D A S H B O A R D'),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Total Sales',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: Future.value(_dailySalesData),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator(color: Colors.white);
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Error: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.white),
                                );
                              } else {
                                final data = snapshot.data!;
                                final totalSales = data.isNotEmpty ? (data.first['total_sales'] ?? 0).toStringAsFixed(2) : '0.00';
                                return Text(
                                  '\₱$totalSales',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            },
                          ),

                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Total Transactions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: Future.value(_dailySalesData),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator(color: Colors.white);
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Error: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.white),
                                );
                              } else {
                                final data = snapshot.data!;
                                final totalTransactions = data.isNotEmpty ? data.first['transactions_count'] ?? 0 : 0; // Corrected column name
                                return Text(
                                  '$totalTransactions',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            },
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const PieChartWidgetMobile(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      drawer: const SidebarMenu(),
    );
  }
}

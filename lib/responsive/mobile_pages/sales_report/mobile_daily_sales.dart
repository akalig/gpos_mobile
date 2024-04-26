import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import '../../../sidebar_menu/sidebar_menu.dart';
import 'package:intl/intl.dart';

class MobileDailySales extends StatefulWidget {
  const MobileDailySales({Key? key}) : super(key: key);

  @override
  _MobileDailySalesState createState() => _MobileDailySalesState();
}

class _MobileDailySalesState extends State<MobileDailySales> {
  List<Map<String, dynamic>> _salesHeaders = [];
  bool _isLoading = true;

  void _refreshSalesHeaders() async {
    final data = await SQLHelper.getSalesHeaders();
    setState(() {
      // Filter sales headers to include only today's sales
      final today = DateTime.now();
      _salesHeaders = data.where((transaction) {
        var transactionDate = DateTime.fromMillisecondsSinceEpoch(transaction['created_at']);
        return transactionDate.year == today.year &&
            transactionDate.month == today.month &&
            transactionDate.day == today.day;
      }).toList();
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshSalesHeaders();
  }


  String formatTimestamp(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(date);
  }

  Future<void> _showSalesDetailsDialog(int transactionCode) async {
    List<Map<String, dynamic>> salesDetails =
        await SQLHelper.getSalesDetailsByTransactionCode(transactionCode);
    // Create a dialog to display the sales details
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sales Details - Transaction Code: $transactionCode'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: salesDetails.map((detail) {
                return ListTile(
                  title: Text('Product: ${detail['description']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sell Price: ${detail['sell_price']}'),
                      Text('Discount: ${detail['discount']}'),
                      Text('Quantity: ${detail['ordering_level']}'),
                      Text('Subtotal: ${detail['subtotal']}'),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('DAILY SALES'),
        centerTitle: true,
        // Add hamburger icon to open the drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 50,
                  columns: const [
                    DataColumn(label: Text('Transaction Code')),
                    DataColumn(label: Text('Subtotal')),
                    DataColumn(label: Text('Discount')),
                    DataColumn(label: Text('Total')),
                    DataColumn(label: Text('Date and Time')),
                  ],
                  rows: _salesHeaders.map((transaction) {
                    return DataRow(cells: [
                      DataCell(Text(transaction['transaction_code'].toString()),
                          onTap: () {
                        _showSalesDetailsDialog(
                            transaction['transaction_code']);
                      }),
                      DataCell(Text(transaction['subtotal'].toString())),
                      DataCell(Text(transaction['total_discount'].toString())),
                      DataCell(Text(transaction['total'].toString())),
                      DataCell(
                          Text(formatTimestamp(transaction['created_at']))),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      // Use SidebarMenu widget as the drawer
      drawer: const SidebarMenu(),
    );
  }
}

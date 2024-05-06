import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import '../../../sidebar_menu/sidebar_menu.dart';
import 'package:intl/intl.dart';

class TabletDailySales extends StatefulWidget {
  const TabletDailySales({Key? key}) : super(key: key);

  @override
  _TabletDashboardState createState() => _TabletDashboardState();
}

class _TabletDashboardState extends State<TabletDailySales> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isDrawerOpen = true;
  List<Map<String, dynamic>> _salesHeaders = [];
  bool _isLoading = true;

  void _refreshSalesHeaders() async {
    final data = await SQLHelper.getSalesHeaders();
    setState(() {
      // Filter sales headers to include only today's sales
      final today = DateTime.now();
      _salesHeaders = data.where((transaction) {
        var transactionDate =
            DateTime.fromMillisecondsSinceEpoch(transaction['created_at']);
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
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _refreshSalesHeaders();
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
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
      key: _scaffoldKey,
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: const Text('DAILY SALES'),
        centerTitle: true,
        // Add hamburger icon to toggle the drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: _isDrawerOpen
                ? const Icon(Icons.menu_open)
                : const Icon(Icons.menu),
            onPressed: _toggleDrawer,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: _isDrawerOpen ? 200 : 0),
            child: Row(
              children: [
                // First column
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        // youtube video
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AspectRatio(
                            aspectRatio: 120 / 9,
                            child: Container(
                              color: Colors.deepPurple[200],
                            ),
                          ),
                        ),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
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
                                DataCell(
                                    Text(transaction['transaction_code']
                                        .toString()), onTap: () {
                                  _showSalesDetailsDialog(
                                      transaction['transaction_code']);
                                }),
                                DataCell(
                                    Text(transaction['subtotal'].toString())),
                                DataCell(Text(
                                    transaction['total_discount'].toString())),
                                DataCell(Text(transaction['total'].toString())),
                                DataCell(Text(formatTimestamp(
                                    transaction['created_at']))),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // second column
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 50,
                    color: Colors.deepPurple[300],
                  ),
                )
              ],
            ),
          ),
          if (_isDrawerOpen)
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: SizedBox(
                width: 200,
                child: SidebarMenu(),
              ),
            ),
        ],
      ),
    );
  }
}

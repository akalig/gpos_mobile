import 'package:flutter/material.dart';
import 'package:gpos_mobile/print/external_print_zread.dart';
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
  List<Map<String, dynamic>> _zReadData = [];
  bool _isLoading = true;
  String totalTransaction = '';
  String grossSales = '';
  String totalDiscount = '';
  String totalSales = '';
  String totalVoid = '';
  String countVoid = '';
  String countDiscount = '';
  String createdAt = '';

  DateTime? _selectDate;

  void _refreshSalesHeaders() async {
    final data = await SQLHelper.getSalesHeaders();
    setState(() {
      // Use the selected date if available, otherwise use today's date
      final filterDate = _selectDate ?? DateTime.now();
      _salesHeaders = data.where((transaction) {
        String dateString = transaction['created_at'];
        DateTime dateTime = DateTime.parse(dateString); // Parse the date string

        return dateTime.year == filterDate.year &&
            dateTime.month == filterDate.month &&
            dateTime.day == filterDate.day;
      }).toList();
      _isLoading = false;
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectDate) {
      setState(() {
        _selectDate = picked;
      });
      _refreshSalesHeaders();
      _refreshZReadData();
    }
  }

  void _refreshZReadData() async {
    final String formattedDate = _selectDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectDate!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now());

    final data = await SQLHelper.getZReadData(formattedDate);
    setState(() {
      _zReadData = data;
      _isLoading = false;

      if (_zReadData.isNotEmpty) {
        Map<String, dynamic> zReadData = _zReadData.first;

        double totalGrossSalesInt = zReadData['total_gross'] ?? 0.0;
        double totalVoidInt = zReadData['total_void'] ?? 0.0;
        double totalDiscountInt = zReadData['total_discount'] ?? 0.0;

        double gross = totalGrossSalesInt - totalVoidInt;
        double sales = gross - totalDiscountInt;

        totalTransaction = zReadData['transactions_count'].toString();
        grossSales = gross.toString();
        totalDiscount = zReadData['total_discount'].toString();
        totalSales = sales.toString();
        totalVoid = zReadData['total_void'].toString();
        countVoid = zReadData['count_void'].toString();
        countDiscount = zReadData['count_discount'].toString();

        DateTime createdAtDate = DateTime.parse(zReadData['created_at']);
        createdAt = DateFormat('MM-dd-yyyy').format(createdAtDate);
      }

    });
  }

  @override
  void initState() {
    super.initState();
    _refreshSalesHeaders();
    _refreshZReadData();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {
              selectDate(context);
            },
            tooltip: 'Select Date',
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Z READ"),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Row(
                            children: [
                              Text("Date: $createdAt"),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Gross Sales Amount:'),
                              Text(grossSales),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Discount Amount:'),
                              Text(totalDiscount),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Sales Amount:'),
                              Text(totalSales),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Transaction:'),
                              Text(totalTransaction),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Discount:'),
                              Text(countDiscount),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Void:'),
                              Text(countVoid),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Void Amount:'),
                              Text(totalVoid),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExternalPrintZRead(
                                    grossSales: grossSales,
                                    totalDiscount: totalDiscount,
                                    totalSales: totalSales,
                                    totalTransaction: totalTransaction,
                                    countDiscount: countDiscount,
                                    countVoid: countVoid,
                                    totalVoid: totalVoid,
                                    date: createdAt)),
                          );
                        },
                        child: const Text('Print'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
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
                DataColumn(label: Text('Status')),
              ],
              rows: _salesHeaders.map((transaction) {
                return DataRow(cells: [
                  DataCell(Text(transaction['transaction_code'].toString()),
                      onTap: () {
                    _showSalesDetailsDialog(transaction['transaction_code']);
                  }),
                  DataCell(Text(transaction['subtotal'].toString())),
                  DataCell(Text(transaction['total_discount'].toString())),
                  DataCell(Text(transaction['total'].toString())),
                  DataCell(Text(formatTimestamp(
                      DateTime.parse(transaction['created_at'])
                          .millisecondsSinceEpoch))),
                  DataCell(Text(transaction['status'].toString())),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
      // Use SidebarMenu widget as the drawer
      drawer: const SidebarMenu(),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../database/database_helper.dart';
import '../../../sidebar_menu/sidebar_menu.dart';
import 'package:intl/intl.dart';

class MobileSalesHistory extends StatefulWidget {
  const MobileSalesHistory({Key? key}) : super(key: key);

  @override
  State<MobileSalesHistory> createState() => _MobileSalesHistoryState();
}

class _MobileSalesHistoryState extends State<MobileSalesHistory> {
  List<Map<String, dynamic>> _salesHeaders = [];
  bool _isLoading = true;
  DateTime? _startDate;
  DateTime? _endDate;

  List<Map<String, dynamic>> _filteredSalesHeaders = [];

  void _filterSalesHeaders() {
    _filteredSalesHeaders = _salesHeaders.where((transaction) {
      var timestamp = transaction['created_at'];
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return (_startDate == null || date.isAfter(_startDate!)) &&
          (_endDate == null || date.isBefore(_endDate!.add(Duration(days: 1))));
    }).toList();
  }

  void _refreshSalesHeaders() async {
    final data = await SQLHelper.getSalesHeaders();
    setState(() {
      _salesHeaders = data;
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

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('SALES HISTORY'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectStartDate(context),
            tooltip: 'Select Start Date',
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectEndDate(context),
            tooltip: 'Select End Date',
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
              ],
              // Remove empty rows and then map the transactions to rows in the DataTable
              rows: _salesHeaders
                  .where((transaction) {
                String dateString = transaction['created_at'];
                DateTime dateTime = DateTime.parse(dateString); // Parse the date string
                var timestamp = dateTime.millisecondsSinceEpoch;
                var date = DateTime.fromMillisecondsSinceEpoch(timestamp);

                return (_startDate == null || date.isAfter(_startDate!)) &&
                    (_endDate == null || date.isBefore(_endDate!.add(Duration(days: 1))));
              })
                  .map((transaction) => DataRow(cells: [
                DataCell(Text(transaction['transaction_code'].toString())),
                DataCell(Text(transaction['subtotal'].toString())),
                DataCell(Text(transaction['total_discount'].toString())),
                DataCell(Text(transaction['total'].toString())),
                DataCell(Text(formatTimestamp(DateTime.parse(transaction['created_at']).millisecondsSinceEpoch))),

              ]))
                  .toList(),
            ),
          ),
        ),
      ),

      // Use SidebarMenu widget as the drawer
      drawer: const SidebarMenu(),
    );
  }
}
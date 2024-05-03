import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../database/database_helper.dart';
import '../../../sidebar_menu/sidebar_menu.dart';

class TabletSalesHistory extends StatefulWidget {
  const TabletSalesHistory({super.key});

  @override
  State<TabletSalesHistory> createState() => _TabletSalesHistoryState();
}

class _TabletSalesHistoryState extends State<TabletSalesHistory> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isDrawerOpen = true;
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
      key: _scaffoldKey,
      backgroundColor: Colors.white60,
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

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
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
                              // Remove empty rows and then map the transactions to rows in the DataTable
                              rows: _salesHeaders
                                  .where((transaction) {
                                var timestamp = transaction['created_at'];
                                var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
                                return (_startDate == null || date.isAfter(_startDate!)) &&
                                    (_endDate == null || date.isBefore(_endDate!.add(Duration(days: 1))));
                              })
                                  .map((transaction) => DataRow(cells: [
                                DataCell(Text(transaction['transaction_code'].toString())),
                                DataCell(Text(transaction['subtotal'].toString())),
                                DataCell(Text(transaction['total_discount'].toString())),
                                DataCell(Text(transaction['total'].toString())),
                                DataCell(Text(formatTimestamp(transaction['created_at']))),
                              ]))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),

                    ],
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../sidebar_menu/sidebar_menu.dart';
import '../../../database/database_helper.dart';

class TabletUserTransaction extends StatefulWidget {
  const TabletUserTransaction({super.key});

  @override
  State<TabletUserTransaction> createState() => _TabletUserTransactionState();
}

class _TabletUserTransactionState extends State<TabletUserTransaction> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isDrawerOpen = true;
  List<Map<String, dynamic>> _userTransaction = [];
  bool _isLoading = true;
  DateTime? _startDate;
  DateTime? _endDate;
  List<Map<String, dynamic>> _filteredUserTransaction = [];

  void _filterUserTransaction() {
    _filteredUserTransaction = _userTransaction.where((transaction) {
      var timestamp = transaction['created_at'];
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return (_startDate == null || date.isAfter(_startDate!)) &&
          (_endDate == null || date.isBefore(_endDate!.add(Duration(days: 1))));
    }).toList();
  }

  void _refreshUserTransaction() async {
    final data = await SQLHelper.getUserTransaction();
    setState(() {
      _userTransaction = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _refreshUserTransaction();
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
        title: const Text('USER TRANSACTION'),
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
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    columnSpacing: 50,
                                    columns: const [
                                      DataColumn(label: Text('Transaction Code')),
                                      DataColumn(label: Text('Staff')),
                                      DataColumn(label: Text('Staff ID')),
                                      DataColumn(label: Text('Status')),
                                      DataColumn(label: Text('Date and Time')),
                                    ],
                                    rows: _userTransaction
                                        .where((transaction) {
                                      String dateString = transaction['created_at'];
                                      DateTime dateTime = DateTime.parse(dateString);
                                      var timestamp = dateTime.millisecondsSinceEpoch;
                                      var date = DateTime.fromMillisecondsSinceEpoch(timestamp);

                                      return (_startDate == null || date.isAfter(_startDate!)) &&
                                          (_endDate == null || date.isBefore(_endDate!.add(Duration(days: 1))));
                                    })
                                        .map((transaction) => DataRow(cells: [
                                      DataCell(Text(transaction['transaction_code'].toString())),
                                      DataCell(Text(transaction['staff_name'].toString())),
                                      DataCell(Text(transaction['staff_id'].toString())),
                                      DataCell(Text(transaction['status'].toString())),
                                      DataCell(Text(formatTimestamp(DateTime.parse(transaction['created_at']).millisecondsSinceEpoch))),
                                    ]))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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

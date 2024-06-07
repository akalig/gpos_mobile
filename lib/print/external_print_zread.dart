import 'package:flutter/material.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:gpos_mobile/pages/sales_report/daily_sales_main.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../database/database_helper.dart';
import '../pages/pos_main.dart';

class ExternalPrintZRead extends StatefulWidget {
  final String grossSales;
  final String totalDiscount;
  final String totalSales;
  final String totalTransaction;
  final String countDiscount;
  final String countVoid;
  final String totalVoid;
  final String date;

  const ExternalPrintZRead({
    super.key,
    required this.grossSales,
    required this.totalDiscount,
    required this.totalSales,
    required this.totalTransaction,
    required this.countDiscount,
    required this.countVoid,
    required this.totalVoid,
    required this.date,
  });

  @override
  State<ExternalPrintZRead> createState() => _ExternalPrintZReadState();
}

class _ExternalPrintZReadState extends State<ExternalPrintZRead> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'No device connected';

  List<Map<String, dynamic>> _companyDetailsData = [];
  List<Map<String, dynamic>> _zReadData = [];
  bool _isLoading = true;

  late String grossSales;
  late String totalDiscount;
  late String totalSales;
  late String totalTransaction;
  late String countDiscount;
  late String countVoid;
  late String totalVoid;
  late String date;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
    _refreshZReadData();
    _refreshCompanyDetailsData();
    grossSales = widget.grossSales;
    totalDiscount = widget.totalDiscount;
    totalSales = widget.totalSales;
    totalTransaction = widget.totalTransaction;
    countDiscount = widget.countDiscount;
    countVoid = widget.countVoid;
    totalVoid = widget.totalVoid;
    date = widget.date;
  }

  void _refreshCompanyDetailsData() async {
    final data = await SQLHelper.getCompanyDetailsData();
    setState(() {
      _companyDetailsData = data;
      _isLoading = false;
    });
  }

  void _refreshZReadData() async {
    final data = await SQLHelper.getZReadData("");
    setState(() {
      _zReadData = data;
      _isLoading = false;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool isConnected = await bluetoothPrint.isConnected ?? false;

    bluetoothPrint.state.listen((state) {
      print('******************* Device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'Device connected successfully';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'Device disconnected successfully';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Print Z READ'),
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              bluetoothPrint.startScan(timeout: const Duration(seconds: 4)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Text(tips),
                    ),
                  ],
                ),
                const Divider(),
                StreamBuilder<List<BluetoothDevice>>(
                  stream: bluetoothPrint.scanResults,
                  initialData: [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!
                        .map((d) => ListTile(
                              title: Text(d.name ?? ''),
                              subtitle: Text(d.address ?? ''),
                              onTap: () async {
                                setState(() {
                                  _device = d;
                                });
                              },
                              trailing: _device != null &&
                                      _device!.address == d.address
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : null,
                            ))
                        .toList(),
                  ),
                ),
                const Divider(),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          OutlinedButton(
                            child: Text('Connect'),
                            onPressed: _connected
                                ? null
                                : () async {
                                    if (_device != null &&
                                        _device!.address != null) {
                                      setState(() {
                                        tips = 'Connecting...';
                                      });
                                      await bluetoothPrint.connect(_device!);
                                    } else {
                                      setState(() {
                                        tips = 'please select device';
                                      });
                                      print('please select device');
                                    }
                                  },
                          ),
                          const SizedBox(width: 10.0),
                          OutlinedButton(
                            child: Text('Disconnect'),
                            onPressed: _connected
                                ? () async {
                                    setState(() {
                                      tips = 'disconnecting...';
                                    });
                                    await bluetoothPrint.disconnect();
                                  }
                                : null,
                          ),
                        ],
                      ),
                      const Divider(),
                      OutlinedButton(
                        child: Text('Print Z READ'),
                        onPressed: _connected
                            ? () async {
                                Map<String, dynamic> config = Map();
                                List<LineText> list = [];

                                Map<String, dynamic> companyData =
                                    _companyDetailsData.first;
                                String companyName =
                                    companyData['company_name'].toString();
                                String companyAddress =
                                    companyData['company_address'].toString();
                                String companyEmail =
                                    companyData['company_email'].toString();
                                String companyMobileNumber =
                                    companyData['company_mobile_number']
                                        .toString();
                                String staffFirstName =
                                    companyData['first_name'].toString();
                                String staffLastName =
                                    companyData['last_name'].toString();
                                String staffFullName =
                                    "$staffFirstName $staffLastName";

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: companyName,
                                    weight: 1,
                                    align: LineText.ALIGN_CENTER,
                                    fontZoom: 2,
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: companyAddress,
                                    weight: 0,
                                    align: LineText.ALIGN_CENTER,
                                    linefeed: 1));
                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: companyEmail,
                                    weight: 0,
                                    align: LineText.ALIGN_CENTER,
                                    linefeed: 1));
                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: '(+63) $companyMobileNumber',
                                    weight: 0,
                                    align: LineText.ALIGN_CENTER,
                                    linefeed: 1));
                                list.add(LineText(linefeed: 1));

                                DateTime now =
                                    DateTime.now(); // Get current date and time
                                String formattedDate =
                                    DateFormat('MM/dd/yyyy').format(now);
                                String formattedTime =
                                    DateFormat('hh:mm a').format(now);

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: '$formattedDate | $formattedTime',
                                  weight: 0,
                                  align: LineText.ALIGN_CENTER,
                                  linefeed: 1,
                                ));
                                list.add(LineText(linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: 'Staff: $staffFullName',
                                    weight: 0,
                                    align: LineText.ALIGN_LEFT,
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: '--------------------------------',
                                    weight: 1,
                                    align: LineText.ALIGN_CENTER,
                                    linefeed: 1));

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: 'Z READ REPORT',
                                    weight: 1,
                                    align: LineText.ALIGN_CENTER,
                                    linefeed: 1));

                                list.add(LineText(linefeed: 1));

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: "Date: $date",
                                  align: LineText.ALIGN_LEFT,
                                  weight: 1,
                                  relativeX: 0,
                                  linefeed: 1,
                                ));

                                list.add(LineText(linefeed: 1));

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: "Gross Sales Amount:",
                                  align: LineText.ALIGN_LEFT,
                                  weight: 1,
                                  relativeX: 0,
                                  linefeed: 0,
                                ));

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: grossSales,
                                  align: LineText.ALIGN_LEFT,
                                  weight: 1,
                                  relativeX: 285,
                                  linefeed: 1,
                                ));

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: "Total Discount Amount:",
                                  align: LineText.ALIGN_LEFT,
                                  weight: 1,
                                  relativeX: 0,
                                  linefeed: 0,
                                ));

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: totalDiscount,
                                  align: LineText.ALIGN_LEFT,
                                  relativeX: 285,
                                  linefeed: 1,
                                ));

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: "Total Sales Amount:",
                                  align: LineText.ALIGN_LEFT,
                                  weight: 1,
                                  relativeX: 0,
                                  linefeed: 0,
                                ));

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: totalSales,
                                  align: LineText.ALIGN_LEFT,
                                  weight: 1,
                                  relativeX: 285,
                                  linefeed: 1,
                                ));

                                list.add(LineText(linefeed: 1));

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: "Total Transaction:",
                                  align: LineText.ALIGN_LEFT,
                                  weight: 1,
                                  relativeX: 0,
                                  linefeed: 0,
                                ));

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: totalTransaction,
                                  align: LineText.ALIGN_LEFT,
                                  weight: 1,
                                  relativeX: 285,
                                  linefeed: 1,
                                ));

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: "Total Discount:",
                                  align: LineText.ALIGN_LEFT,
                                  weight: 1,
                                  relativeX: 0,
                                  linefeed: 0,
                                ));

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: countDiscount,
                                  align: LineText.ALIGN_LEFT,
                                  weight: 1,
                                  relativeX: 285,
                                  linefeed: 1,
                                ));

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: "Total Void:",
                                  align: LineText.ALIGN_LEFT,
                                  weight: 1,
                                  relativeX: 0,
                                  linefeed: 0,
                                ));

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: countVoid,
                                  align: LineText.ALIGN_LEFT,
                                  weight: 1,
                                  relativeX: 285,
                                  linefeed: 1,
                                ));

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: "Total Void Amount:",
                                  align: LineText.ALIGN_LEFT,
                                  weight: 1,
                                  relativeX: 0,
                                  linefeed: 0,
                                ));

                                list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: totalVoid,
                                  align: LineText.ALIGN_LEFT,
                                  weight: 1,
                                  relativeX: 285,
                                  linefeed: 1,
                                ));

                                list.add(LineText(linefeed: 1));
                                list.add(LineText(linefeed: 1));

                                await bluetoothPrint.printReceipt(config, list);
                              }
                            : null,
                      ),
                      OutlinedButton(
                        child: const Text('Finish'),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DailySalesMain()), // Replace with your actual Home widget
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: bluetoothPrint.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data == true) {
              return FloatingActionButton(
                child: Icon(Icons.stop),
                onPressed: () => bluetoothPrint.stopScan(),
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(
                  child: Icon(Icons.search),
                  onPressed: () =>
                      bluetoothPrint.startScan(timeout: Duration(seconds: 4)));
            }
          },
        ),
      ),
    );
  }
}

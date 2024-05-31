import 'package:flutter/material.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../database/database_helper.dart';
import '../pages/pos_main.dart';

class ExternalPrintReceipt extends StatefulWidget {
  const ExternalPrintReceipt({super.key});

  @override
  State<ExternalPrintReceipt> createState() => _ExternalPrintReceiptState();
}

class _ExternalPrintReceiptState extends State<ExternalPrintReceipt> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'No device connected';

  List<Map<String, dynamic>> _onTransaction = [];
  List<Map<String, dynamic>> _companyDetailsData = [];
  bool _isLoading = true;

  void _refreshCompanyDetailsData() async {
    final data = await SQLHelper.getCompanyDetailsData();
    setState(() {
      _companyDetailsData = data;
      _isLoading = false;
    });
  }

  void _refreshOnTransaction() async {
    final data = await SQLHelper.getOnTransaction();
    setState(() {
      _onTransaction = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
    _refreshOnTransaction();
    _refreshCompanyDetailsData();
  }

  /// * TRUNCATE ON TRANSACTION CLASS **
  Future<void> _truncateOnTransaction() async {
    await SQLHelper.truncateOnTransaction();
    _refreshOnTransaction();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool isConnected=await bluetoothPrint.isConnected??false;

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

    if(isConnected) {
      setState(() {
        _connected=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Print Receipt'),
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
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(tips),
                    ),
                  ],
                ),
                const Divider(),
                StreamBuilder<List<BluetoothDevice>>(
                  stream: bluetoothPrint.scanResults,
                  initialData: [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!.map((d) => ListTile(
                      title: Text(d.name??''),
                      subtitle: Text(d.address??''),
                      onTap: () async {
                        setState(() {
                          _device = d;
                        });
                      },
                      trailing: _device!=null && _device!.address == d.address? const Icon(
                        Icons.check,
                        color: Colors.green,
                      ):null,
                    )).toList(),
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
                            onPressed:  _connected?null:() async {
                              if(_device!=null && _device!.address !=null){
                                setState(() {
                                  tips = 'Connecting...';
                                });
                                await bluetoothPrint.connect(_device!);
                              }else{
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
                            onPressed:  _connected?() async {
                              setState(() {
                                tips = 'disconnecting...';
                              });
                              await bluetoothPrint.disconnect();
                            }:null,
                          ),
                        ],
                      ),
                      const Divider(),
                      OutlinedButton(
                        child: Text('Print Receipt'),
                        onPressed:  _connected?() async {
                          Map<String, dynamic> config = Map();
                          List<LineText> list = [];

                          Map<String, dynamic> companyData = _companyDetailsData.first;
                          String companyName = companyData['company_name'].toString();
                          String companyAddress = companyData['company_address'].toString();
                          String companyEmail = companyData['company_email'].toString();
                          String companyMobileNumber = companyData['company_mobile_number'].toString();
                          String staffFirstName = companyData['first_name'].toString();
                          String staffLastName = companyData['last_name'].toString();
                          String staffFullName = "$staffFirstName $staffLastName";

                          list.add(LineText(type: LineText.TYPE_TEXT, content: companyName, weight: 1, align: LineText.ALIGN_CENTER, fontZoom: 2, linefeed: 1));

                          list.add(LineText(type: LineText.TYPE_TEXT, content: companyAddress, weight: 0, align: LineText.ALIGN_CENTER,linefeed: 1));
                          list.add(LineText(type: LineText.TYPE_TEXT, content: companyEmail, weight: 0, align: LineText.ALIGN_CENTER,linefeed: 1));
                          list.add(LineText(type: LineText.TYPE_TEXT, content: '(+63) $companyMobileNumber', weight: 0, align: LineText.ALIGN_CENTER,linefeed: 1));
                          list.add(LineText(linefeed: 1));

                          DateTime now = DateTime.now(); // Get current date and time
                          String formattedDate = DateFormat('MM/dd/yyyy').format(now);
                          String formattedTime = DateFormat('hh:mm a').format(now);

                          list.add(LineText(
                            type: LineText.TYPE_TEXT,
                            content: '$formattedDate | $formattedTime',
                            weight: 0,
                            align: LineText.ALIGN_CENTER,
                            linefeed: 1,
                          ));
                          list.add(LineText(linefeed: 1));

                          list.add(LineText(type: LineText.TYPE_TEXT, content: 'Staff: $staffFullName', weight: 0, align: LineText.ALIGN_LEFT,linefeed: 1));

                          list.add(LineText(type: LineText.TYPE_TEXT, content: '--------------------------------', weight: 1, align: LineText.ALIGN_CENTER,linefeed: 1));

                          list.add(LineText(
                            type: LineText.TYPE_TEXT,
                            content: "Qty",
                            align: LineText.ALIGN_LEFT,
                            relativeX: 0,
                            linefeed: 0,
                          ));

                          list.add(LineText(
                            type: LineText.TYPE_TEXT,
                            content: "Item",
                            align: LineText.ALIGN_LEFT,
                            relativeX: 50,
                            linefeed: 0,
                          ));

                          // list.add(LineText(
                          //   type: LineText.TYPE_TEXT,
                          //   content: "Price",
                          //   align: LineText.ALIGN_LEFT,
                          //   relativeX: 210,
                          //   linefeed: 0,
                          // ));

                          list.add(LineText(
                            type: LineText.TYPE_TEXT,
                            content: "Price",
                            align: LineText.ALIGN_LEFT,
                            relativeX: 285,
                            linefeed: 1,
                          ));

                          _onTransaction.forEach((transaction) {

                            list.add(LineText(
                              type: LineText.TYPE_TEXT,
                              content: transaction['ordering_level'].toString(),
                              align: LineText.ALIGN_LEFT,
                              relativeX: 0,
                              linefeed: 0,
                            ));

                            list.add(LineText(
                              type: LineText.TYPE_TEXT,
                              content: transaction['description'].toString(),
                              align: LineText.ALIGN_LEFT,
                              relativeX: 50,
                              linefeed: 0,
                            ));

                            list.add(LineText(
                              type: LineText.TYPE_TEXT,
                              content: transaction['sell_price'].toStringAsFixed(2),
                              align: LineText.ALIGN_LEFT,
                              relativeX: 285,
                              linefeed: 1,
                            ));

                            // list.add(LineText(
                            //   type: LineText.TYPE_TEXT,
                            //   content: transaction['total'].toStringAsFixed(2),
                            //   align: LineText.ALIGN_LEFT,
                            //   relativeX: 285,
                            //   linefeed: 1,
                            // ));

                          });

                          list.add(LineText(
                            type: LineText.TYPE_TEXT,
                            content: "12345678901234567890123456789012",
                            align: LineText.ALIGN_LEFT,
                            relativeX: 0,
                            linefeed: 1,
                          ));

                          list.add(LineText(type: LineText.TYPE_TEXT, content: '--------------------------------', weight: 1, align: LineText.ALIGN_CENTER,linefeed: 1));

                          list.add(LineText(
                            type: LineText.TYPE_TEXT,
                            content: "Subtotal",
                            align: LineText.ALIGN_LEFT,
                            relativeX: 0,
                            linefeed: 0,
                          ));

                          list.add(LineText(
                            type: LineText.TYPE_TEXT,
                            content: calculateSubtotal().toStringAsFixed(2),
                            align: LineText.ALIGN_LEFT,
                            relativeX: 285,
                            linefeed: 1,
                          ));

                          list.add(LineText(
                            type: LineText.TYPE_TEXT,
                            content: "Total Discount",
                            align: LineText.ALIGN_LEFT,
                            relativeX: 0,
                            linefeed: 0,
                          ));

                          list.add(LineText(
                            type: LineText.TYPE_TEXT,
                            content: calculateTotalDiscount().toStringAsFixed(2),
                            align: LineText.ALIGN_LEFT,
                            relativeX: 285,
                            linefeed: 1,
                          ));

                          list.add(LineText(
                            type: LineText.TYPE_TEXT,
                            content: "Total",
                            align: LineText.ALIGN_LEFT,
                            weight: 1,
                            fontZoom: 1,
                            relativeX: 0,
                            linefeed: 0,
                          ));

                          list.add(LineText(
                            type: LineText.TYPE_TEXT,
                            content: calculateTotal().toStringAsFixed(2),
                            align: LineText.ALIGN_LEFT,
                            weight: 1,
                            fontZoom: 1,
                            relativeX: 285,
                            linefeed: 1,
                          ));

                          list.add(LineText(linefeed: 1));

                          // ByteData data = await rootBundle.load('lib/assets/images/greatpos_logo.png');
                          // List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
                          // String base64Image = base64Encode(imageBytes);
                          // list.add(LineText(type: LineText.TYPE_IMAGE, content: base64Image, align: LineText.ALIGN_CENTER, linefeed: 1));

                          await bluetoothPrint.printReceipt(config, list);
                        }:null,
                      ),

                      OutlinedButton(
                        child: Text('Finish'),
                        onPressed: () {

                          _truncateOnTransaction();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const POSMain()), // Replace with your actual Home widget
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
                  onPressed: () => bluetoothPrint.startScan(timeout: Duration(seconds: 4)));
            }
          },
        ),
      ),
    );
  }

  double calculateTotal() {
    double total = 0.0;
    for (var transaction in _onTransaction) {
      total += transaction['total'] as double;
    }
    return total;
  }

  double calculateSubtotal() {
    double total = 0.0;
    for (var transaction in _onTransaction) {
      total += transaction['subtotal'] as double;
    }
    return total;
  }

  double calculateTotalDiscount() {
    double total = 0.0;
    for (var transaction in _onTransaction) {
      total += transaction['discount'] as double;
    }
    return total;
  }

  int calculateQuantity() {
    int total = 0;
    for (var transaction in _onTransaction) {
      total += transaction['ordering_level'] as int;
    }
    return total;
  }

}
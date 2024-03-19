import 'package:flutter/material.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';

class CheckoutReceipt extends StatefulWidget {
  const CheckoutReceipt({super.key});

  @override
  State<CheckoutReceipt> createState() => _CheckoutReceiptState();
}

class _CheckoutReceiptState extends State<CheckoutReceipt> {
  List<Map<String, dynamic>> _onTransaction = [];
  bool _isLoading = true;
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _devicesMsg = "";
  final f = NumberFormat("\$###,###.00", "en_US");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => {initPrinter()});
  }

  Future<void> initPrinter() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 2));

    if (!mounted) return;

    bluetoothPrint.scanResults.listen(
          (val) {
        if (!mounted) return;
        setState(() {
          _devices = val;
        });
        if (_devices.isEmpty) {
          setState(() {
            _devicesMsg = "No Devices";
          });
        }
      },
    );
  }

  void _refreshOnTransaction() async {
    final data = await SQLHelper.getOnTransaction();
    setState(() {
      _onTransaction = data;
      _isLoading = false;
    });
  }

  /// * ADD SALES HEADERS CLASS **
  Future<void> _addSalesHeaders(double subtotal, double totalDiscount,
      double total, String amountPaid) async {
    await SQLHelper.createSalesHeaders(
        subtotal, totalDiscount, total, amountPaid);
  }

  /// * ADD SALES DETAILS CLASS **
  Future<void> _addSalesDetails() async {
    await SQLHelper.createSalesDetails();
  }

  /// * ADD TRUNCATE ON TRANSACTION CLASS **
  Future<void> _truncateOnTransaction() async {
    await SQLHelper.truncateOnTransaction();
    _refreshOnTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Receipt'),
      ),
      body: _devices.isEmpty ? Center(child: Text(_devicesMsg ?? ''),) :
      ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (c, i) {
          return ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Print Receipt'),
            subtitle: Text(_devices[i].name.toString()),
            onTap: () {
              _startPrint(_devices[i]);
            },
          );
        },
      ),
    );
  }

  Future<void> _startPrint(BluetoothDevice device) async {
    if (device != null && device.address != null) {
      await bluetoothPrint.connect(device);

      Map<String, dynamic> config = Map();
      List<LineText> list = [];

      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: "GPOS Mobile",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ),
      );

      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: "Sample 1",
          weight: 0,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
        ),
      );

      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: "Sample 2",
          weight: 0,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
        ),
      );

      // // Fetch transaction data from the database
      // final transactions = await SQLHelper.getOnTransaction();
      //
      // // Iterate over the transactions list
      // for (var i = 0; i < transactions.length; i++) {
      //   var transaction = transactions[i];
      //
      //   list.add(
      //     LineText(
      //       type: LineText.TYPE_TEXT,
      //       content: "${transaction['description']} | ${transaction['ordering_level']} | ${transaction['total']}",
      //       weight: 0,
      //       align: LineText.ALIGN_LEFT,
      //       linefeed: 1,
      //     ),
      //   );
      // }

      // After iterating over transactions, proceed with printing
      // You can now use the `list` variable containing the content to be printed
      // Example: await bluetoothPrint.printReceipt(configs: config, content: list);
    }
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

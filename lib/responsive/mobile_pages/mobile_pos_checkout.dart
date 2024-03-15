import 'package:flutter/material.dart';
import 'package:gpos_mobile/print/checkout_receipt.dart';
import '../../pages/pos_main.dart';
import 'package:gpos_mobile/database/database_helper.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

class MobilePOSCheckout extends StatefulWidget {
  const MobilePOSCheckout({super.key});

  @override
  State<MobilePOSCheckout> createState() => _MobilePOSCheckoutState();
}

class _MobilePOSCheckoutState extends State<MobilePOSCheckout> {
  List<Map<String, dynamic>> _onTransaction = [];
  bool _isLoading = true;
  late TextEditingController _editDiscountController;
  late TextEditingController _amountPaidController;

  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _devicesMsg = "";

  void _refreshOnTransaction() async {
    final data = await SQLHelper.getOnTransaction();
    setState(() {
      _editDiscountController.text = '';
      _onTransaction = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _editDiscountController = TextEditingController();
    _amountPaidController = TextEditingController();
    _refreshOnTransaction();
  }

  /// * ADD EDIT DISCOUNT CLASS **
  Future<void> _addEditDiscount(int productNumber, String stDiscount) async {
    double discount = double.parse(stDiscount);

    await SQLHelper.updateDiscount(productNumber, discount);
    _refreshOnTransaction();
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
    _amountPaidController.text = '';
    _refreshOnTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('B A S K E T'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: 50,
                    columns: const [
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Subtotal')),
                      DataColumn(label: Text('Discount')),
                      DataColumn(label: Text('Total')),
                    ],
                    rows: _onTransaction.map((transaction) {
                      return DataRow(cells: [
                        DataCell(Text(transaction['description'])),
                        DataCell(Text(transaction['sell_price'].toString())),
                        DataCell(
                            Text(transaction['ordering_level'].toString())),
                        DataCell(Text(transaction['subtotal'].toString())),
                        DataCell(GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Discount Details"),
                                  content: TextField(
                                    controller: _editDiscountController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Discount',
                                      suffixIcon: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                          '%',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        _addEditDiscount(
                                            transaction['product_code'],
                                            _editDiscountController.text);

                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Submit'),
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
                          child: Text(transaction['discount'].toString()),
                        )),
                        DataCell(Text(transaction['total'].toString())),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Subtotal: ${calculateSubtotal()}'),
                  const SizedBox(height: 5),
                  Text('Total Discount: ${calculateTotalDiscount()}'),
                  const SizedBox(height: 5),
                  Text('Total: ${calculateTotal()}'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Payment"),
                      content: TextField(
                        controller: _amountPaidController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Payment',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              '₱',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CheckoutReceipt(),
                              ),
                            );

                            // Parse the amount paid to a double
                            // double amountPaid =
                            //     double.tryParse(_amountPaidController.text) ??
                            //         0.0;
                            //
                            // // Calculate the total
                            // double total = calculateTotal();
                            //
                            // // Check if amount paid is sufficient
                            // if (amountPaid >= total) {
                            //   // Proceed with submitting the sales details
                            //   _addSalesDetails();
                            //
                            //   // Add a delay if needed
                            //   Future.delayed(const Duration(seconds: 2));
                            //
                            //   // Add sales headers
                            //   _addSalesHeaders(
                            //       calculateSubtotal(),
                            //       calculateTotalDiscount(),
                            //       total,
                            //       amountPaid.toString());
                            //
                            //   // Add a delay if needed
                            //   Future.delayed(const Duration(seconds: 2));
                            //
                            //   // Truncate on_transaction table
                            //   _truncateOnTransaction();
                            //
                            //   // Navigator.pushReplacement(
                            //   //   context,
                            //   //   MaterialPageRoute(
                            //   //       builder: (context) =>
                            //   //           const POSMain()), // Replace with your actual Home widget
                            //   // );
                            //
                            // } else {
                            //   // Show error message for insufficient payment
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //         title: const Text("Error"),
                            //         content: const Text(
                            //             "Insufficient amount. Please enter a higher amount."),
                            //         actions: <Widget>[
                            //           TextButton(
                            //             onPressed: () {
                            //               Navigator.of(context).pop();
                            //             },
                            //             child: const Text('Close'),
                            //           ),
                            //         ],
                            //       );
                            //     },
                            //   );
                            // }
                          },
                          child: const Text('Submit'),
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
              child: const Text('Payment'),
            ),
          ],
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

import 'package:flutter/material.dart';
import 'package:gpos_mobile/print/external_print.dart';
import '../../pages/pos_main.dart';
import 'package:gpos_mobile/database/database_helper.dart';

import '../../print/internal_print.dart';
// import 'package:bluetooth_print/bluetooth_print.dart';
// import 'package:bluetooth_print/bluetooth_print_model.dart';

class MobilePOSCheckout extends StatefulWidget {
  const MobilePOSCheckout({super.key});

  @override
  State<MobilePOSCheckout> createState() => _MobilePOSCheckoutState();
}

class _MobilePOSCheckoutState extends State<MobilePOSCheckout> {
  List<Map<String, dynamic>> _onTransaction = [];
  bool _isLoading = true;
  late TextEditingController _editDiscountController;
  late TextEditingController _editQuantityController;
  late TextEditingController _amountPaidController;

  // BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  // List<BluetoothDevice> _devices = [];
  // String _devicesMsg = "";

  void _refreshOnTransaction() async {
    final data = await SQLHelper.getOnTransaction();
    setState(() {
      _editDiscountController.text = '';
      _editQuantityController.text = '';
      _onTransaction = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _editDiscountController = TextEditingController();
    _editQuantityController = TextEditingController();
    _amountPaidController = TextEditingController();
    _refreshOnTransaction();
  }

  /// * ADD EDIT DISCOUNT CLASS **
  Future<void> _addEditDiscount(int productNumber, String stDiscount) async {
    double discount = double.parse(stDiscount);

    await SQLHelper.updateDiscount(productNumber, discount);
    _refreshOnTransaction();
  }

  /// * ADD EDIT QUANTITY CLASS **
  Future<void> _addEditQuantity(int productNumber, String stQuantity) async {
    int quantity = int.parse(stQuantity);

    await SQLHelper.updateQuantity(productNumber, quantity);
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

  /// * TRUNCATE ON TRANSACTION CLASS **
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
                        DataCell(
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                transaction['sell_price'].toStringAsFixed(2)),
                          ),
                        ),
                        DataCell(GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Quantity Details"),
                                  content: TextField(
                                    controller: _editQuantityController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter New Quantity',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        _addEditQuantity(
                                            transaction['product_code'],
                                            _editQuantityController.text);

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
                          child: Align(
                            alignment: Alignment.centerRight,
                            child:
                                Text(transaction['ordering_level'].toString()),
                          ),
                        )),
                        DataCell(
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                transaction['subtotal'].toStringAsFixed(2)),
                          ),
                        ),
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
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                transaction['discount'].toStringAsFixed(2)),
                          ),
                        )),
                        DataCell(
                          Align(
                            alignment: Alignment.centerRight,
                            child:
                                Text(transaction['total'].toStringAsFixed(2)),
                          ),
                        ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:'),
                      Text('₱ ${calculateSubtotal().toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Discount:'),
                      Text('₱ ${calculateTotalDiscount().toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:'),
                      Text('₱ ${calculateTotal().toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                                // Parse the amount paid to a double
                                double amountPaid = double.tryParse(
                                        _amountPaidController.text) ??
                                    0.0;

                                // Calculate the total
                                double total = calculateTotal();

                                // Check if amount paid is sufficient
                                if (amountPaid >= total) {
                                  // Proceed with submitting the sales details
                                  _addSalesDetails();

                                  // Add a delay if needed
                                  Future.delayed(const Duration(seconds: 2));

                                  // Add sales headers
                                  _addSalesHeaders(
                                      calculateSubtotal(),
                                      calculateTotalDiscount(),
                                      total,
                                      amountPaid.toString());

                                  // Add a delay if needed
                                  Future.delayed(const Duration(seconds: 2));

                                  // Truncate on_transaction table
                                  // _truncateOnTransaction();

                                  double change = amountPaid - total;

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Sale Summary"),
                                        contentPadding: EdgeInsets.zero,
                                        content: SingleChildScrollView(
                                          child: Container(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Subtotal:'),
                                                    Text(
                                                        '₱ ${calculateSubtotal().toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                        'Total Discount:'),
                                                    Text(
                                                        '- ₱ ${calculateTotalDiscount().toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Total:'),
                                                    Text(
                                                        '₱ ${total.toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                        'Amount received:'),
                                                    Text(
                                                        '₱ ${amountPaid.toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                const Divider(
                                                  color: Colors.black,
                                                  // You can customize the color
                                                  thickness:
                                                      1, // You can customize the thickness
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text('Change:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16)),
                                                    Text(
                                                        '₱ ${change.toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {

                                              // Navigator.pushReplacement(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           const POSMain()), // Replace with your actual Home widget
                                              // );

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => ExternalPrintReceipt(),
                                                ),
                                              );

                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (_) => InternalPrintReceipt(),
                                              //   ),
                                              // );

                                            },
                                            child: const Text('Finish'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // Show error message for insufficient payment
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Error"),
                                        content: const Text(
                                            "Insufficient amount. Please enter a higher amount."),
                                        actions: <Widget>[
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
                                }
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
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Cancel Transaction"),
                          content: const Text(
                              "Do you want to cancel this Transaction?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                // Truncate on_transaction table
                                _truncateOnTransaction();

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const POSMain()),
                                );
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('No'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Cancel Transaction',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
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

import 'package:flutter/material.dart';
import '../../pages/pos_main.dart';
import '../../sidebar_menu/sidebar_menu.dart';
import 'package:gpos_mobile/database/database_helper.dart';
import 'dart:typed_data';

class MobilePOS extends StatefulWidget {
  const MobilePOS({Key? key}) : super(key: key);

  @override
  _MobilePOSState createState() => _MobilePOSState();
}

class _MobilePOSState extends State<MobilePOS> {
  List<Map<String, dynamic>> _productsDetails = [];
  List<Map<String, dynamic>> _onTransaction = [];
  List<Map<String, dynamic>> _salesHeaders = [];
  bool _isLoading = true;
  late TextEditingController _editDiscountController;
  late TextEditingController _amountPaidController;

  void _refreshProductsDetails() async {
    final data = await SQLHelper.getProductsDetails();
    setState(() {
      _productsDetails = data;
      _isLoading = false;
    });
  }

  void _refreshOnTransaction() async {
    final data = await SQLHelper.getOnTransaction();
    setState(() {
      _editDiscountController.text = '';
      _onTransaction = data;
      _isLoading = false;
    });
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
    _editDiscountController = TextEditingController();
    _amountPaidController = TextEditingController();
    _refreshProductsDetails();
    _refreshOnTransaction();
    _refreshSalesHeaders();
  }

  /// * ADD EDIT DISCOUNT CLASS **
  Future<void> _addEditDiscount(int productNumber, String stDiscount) async {
    double discount = double.parse(stDiscount);

    await SQLHelper.updateDiscount(productNumber, discount);
    _refreshProductsDetails();
    _refreshOnTransaction();
    _refreshSalesHeaders();
  }

  /// * ADD ON TRANSACTION CLASS **
  Future<void> _addOnTransaction(
      int productCode, String description, double sellPrice) async {
    await SQLHelper.createOnTransaction(
        productCode, description, sellPrice, 0.0);

    _refreshProductsDetails();
    _refreshOnTransaction();
    _refreshSalesHeaders();
  }

  /// * ADD SALES HEADERS CLASS **
  Future<void> _addSalesHeaders(double subtotal, double total_discount, double total, String amountPaid) async {
    await SQLHelper.createSalesHeaders(subtotal, total_discount, total, amountPaid);
  }

  /// * ADD SALES DETAILS CLASS **
  Future<void> _addSalesDetails() async {
    await SQLHelper.createSalesDetails();
  }

  /// * ADD TRUNCATE ON TRANSACTION CLASS **
  Future<void> _truncateOnTransaction() async {
    await SQLHelper.truncateOnTransaction();
    _amountPaidController.text = '';
    _refreshProductsDetails();
    _refreshOnTransaction();
    _refreshSalesHeaders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: const Text('P O S'),
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
        // Add additional icon to the right side
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Transaction History"),
                    content: Column(
                      children: [
                        SingleChildScrollView(
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
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: _salesHeaders.map((transaction) {
                                return DataRow(cells: [
                                  DataCell(Text(transaction['transaction_code'].toString())),
                                  DataCell(Text(transaction['subtotal'].toString())),
                                  DataCell(Text(transaction['total_discount'].toString())),
                                  DataCell(Text(transaction['total'].toString())),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Handle button press
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.red,
                                            // text color
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          child: const Text('Void'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
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
            },
          ),
        ],

      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                aspectRatio: 110 / 9,
                child: Container(
                  color: Colors.deepPurple[200],
                ),
              ),
            ),

            // comment section & recommended videos
            /*** PRODUCT DETAILS LIST ***/
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: _productsDetails.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _addOnTransaction(
                          _productsDetails[index]['product_code'],
                          _productsDetails[index]['description'],
                          _productsDetails[index]['sell_price']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.deepPurple[300],
                        height: 80,
                        width: 80,
                        child: Stack(
                          children: [
                            if (_productsDetails[index]['image'] != null &&
                                (_productsDetails[index]['image'] as Uint8List)
                                    .isNotEmpty)
                              Image.memory(
                                _productsDetails[index]['image'],
                                // No need for null check, already checked
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                              ),
                            Container(
                              color: Colors.black.withOpacity(0.5),
                              height: double.infinity,
                              width: double.infinity,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    _productsDetails[index]['description'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Price: ₱${_productsDetails[index]['sell_price'].toString()}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Visibility(
              visible: _onTransaction != null && _onTransaction.isNotEmpty,
              child: GestureDetector(
                onTap: () {
                  if (_onTransaction != null && _onTransaction.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Basket'),
                          content: Column(
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
                                          DataCell(Text(transaction['ordering_level'].toString())),
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
                                padding: const EdgeInsets.only(top: 8.0),
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
                            ],
                          ),
                          actions: <Widget>[
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
                                            double amountPaid = double.tryParse(_amountPaidController.text) ?? 0.0;

                                            // Calculate the total
                                            double total = calculateTotal();

                                            // Check if amount paid is sufficient
                                            if (amountPaid >= total) {
                                              // Proceed with submitting the sales details
                                              _addSalesDetails();

                                              // Add a delay if needed
                                              Future.delayed(const Duration(seconds: 2));

                                              // Add sales headers
                                              _addSalesHeaders(calculateSubtotal(), calculateTotalDiscount(), total, amountPaid.toString());

                                              // Add a delay if needed
                                              Future.delayed(const Duration(seconds: 2));

                                              // Truncate on_transaction table
                                              _truncateOnTransaction();

                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                    const POSMain()), // Replace with your actual Home widget
                                              );
                                            } else {
                                              // Show error message for insufficient payment
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text("Error"),
                                                    content: const Text("Insufficient amount. Please enter a higher amount."),
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
                              child: const Text('Pay'),
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
                  }
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[500],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'Basket (${calculateQuantity()} items)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Use SidebarMenu widget as the drawer
      drawer: const SidebarMenu(),
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

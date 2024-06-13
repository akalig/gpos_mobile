import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../pages/pos_main.dart';
import '../../sidebar_menu/sidebar_menu.dart';
// import 'package:bluetooth_print/bluetooth_print.dart';
// import 'package:bluetooth_print/bluetooth_print_model.dart';

class TabletPOS extends StatefulWidget {
  const TabletPOS({Key? key}) : super(key: key);

  @override
  _TabletPOSState createState() => _TabletPOSState();
}

class _TabletPOSState extends State<TabletPOS> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isDrawerOpen = true;
  List<Map<String, dynamic>> _productsDetails = [];
  List<Map<String, dynamic>> _onTransaction = [];
  List<Map<String, dynamic>> _salesHeaders = [];
  List<Map<String, dynamic>> _loggedUserDetailsData = [];
  late TextEditingController _editDiscountController;
  late TextEditingController _editQuantityController;
  late TextEditingController _amountPaidController;
  bool _isLoading = true;

  // BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  // List<BluetoothDevice> _devices = [];
  // String _devicesMsg = "";

  SQLHelper _sqlHelper = SQLHelper();
  TextEditingController _searchController = TextEditingController();

  void _refreshProductsDetails() async {
    final data = await SQLHelper.getProductsDetails();
    setState(() {
      _productsDetails = data;
      _isLoading = false;
    });
  }

  void _refreshLoggedUserDetailsData() async {
    final data = await SQLHelper.getLoggedUserData();
    setState(() {
      _loggedUserDetailsData = data;
      _isLoading = false;
    });
  }

  void _refreshOnTransaction() async {
    final data = await SQLHelper.getOnTransaction();
    setState(() {
      _onTransaction = data;
      _editDiscountController.text = '';
      _editQuantityController.text = '';
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
    _editQuantityController = TextEditingController();
    _amountPaidController = TextEditingController();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _refreshProductsDetails();
    _refreshOnTransaction();
    _refreshSalesHeaders();
    _refreshLoggedUserDetailsData();
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
      double total, String amountPaid, String staffName, int staffID) async {
    await SQLHelper.createSalesHeaders(
        subtotal, totalDiscount, total, amountPaid, staffName, staffID);
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

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  void _performSearch(String searchTerm) async {
    final results = await _sqlHelper.searchProducts(searchTerm); // Call the method using the instance
    setState(() {
      _productsDetails = results;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        title: const Text('P O S'),
        centerTitle: true,
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
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset:
                                const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: const InputDecoration(
                                      hintText: 'Search',
                                      border: InputBorder.none,
                                      hintStyle:
                                          TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10.0),
                                  onTap: () {
                                    _performSearch(_searchController.text);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // comment section & recommended videos
                      /*** PRODUCT DETAILS LIST ***/
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: _productsDetails.length,
                          itemBuilder: (context, index) {

                            if (_productsDetails[index]['ordering_level'] <= 0) {

                              return GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Product is out of Stock'),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    foregroundDecoration: const BoxDecoration(
                                      color: Colors.grey,
                                      backgroundBlendMode: BlendMode.saturation,
                                    ),
                                    color: Colors.deepPurple[300],
                                    height: 80,
                                    width: 80,
                                    child: Stack(
                                      children: [
                                        if (_productsDetails[index]['image'] !=
                                            null &&
                                            (_productsDetails[index]['image']
                                            as Uint8List)
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
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                _productsDetails[index]
                                                ['description'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 1),
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                'Out of Stock',
                                                style: TextStyle(
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
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  final productDetails = _productsDetails[index];
                                  final transactionIndex = _onTransaction.indexWhere((transaction) =>
                                  transaction['product_code'] == productDetails['product_code']);

                                  if (transactionIndex != -1 &&
                                      _onTransaction[transactionIndex]['ordering_level'] >=
                                          productDetails['ordering_level']) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('You exceed the quantity of the Product'),
                                      ),
                                    );
                                  } else {
                                    _addOnTransaction(
                                        productDetails['product_code'],
                                        productDetails['description'],
                                        productDetails['sell_price']
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    color: Colors.deepPurple[300],
                                    height: 80,
                                    width: 80,
                                    child: Stack(
                                      children: [
                                        if (_productsDetails[index]['image'] !=
                                            null &&
                                            (_productsDetails[index]['image']
                                            as Uint8List)
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
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                _productsDetails[index]
                                                ['description'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 1),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
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
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // second column
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 350,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
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
                                      DataCell(
                                          Text(transaction['description'])),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(transaction['sell_price']
                                              .toStringAsFixed(2)),
                                        ),
                                      ),
                                      DataCell(GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Quantity Details"),
                                                content: TextField(
                                                  controller:
                                                      _editQuantityController,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        'Enter New Quantity',
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () async {
                                                      _addEditQuantity(
                                                          transaction[
                                                              'product_code'],
                                                          _editQuantityController
                                                              .text);

                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Submit'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
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
                                              transaction['ordering_level']
                                                  .toString()),
                                        ),
                                      )),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(transaction['subtotal']
                                              .toStringAsFixed(2)),
                                        ),
                                      ),
                                      DataCell(GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Discount Details"),
                                                content: TextField(
                                                  controller:
                                                      _editDiscountController,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: 'Enter Discount',
                                                    suffixIcon: Padding(
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      child: Text(
                                                        '%',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () async {
                                                      _addEditDiscount(
                                                          transaction[
                                                              'product_code'],
                                                          _editDiscountController
                                                              .text);

                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Submit'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
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
                                          child: Text(transaction['discount']
                                              .toStringAsFixed(2)),
                                        ),
                                      )),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(transaction['total']
                                              .toStringAsFixed(2)),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Subtotal:'),
                                    Text(
                                        '₱ ${calculateSubtotal().toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total Discount:'),
                                    Text(
                                        '₱ ${calculateTotalDiscount().toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total:'),
                                    Text(
                                        '₱ ${calculateTotal().toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
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
                                  if (_onTransaction.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Basket is Empty'),
                                      ),
                                    );
                                  } else {
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
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (_) => const CheckoutReceipt(),
                                                //   ),
                                                // );

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

                                                  Map<String, dynamic> loggedUserData = _loggedUserDetailsData.first;
                                                  String staffFirstName = loggedUserData['first_name'].toString();
                                                  String staffLastName = loggedUserData['last_name'].toString();
                                                  int staffID = loggedUserData['id'];
                                                  String staffFullName = "$staffFirstName $staffLastName";

                                                  // Add sales headers
                                                  _addSalesHeaders(
                                                      calculateSubtotal(),
                                                      calculateTotalDiscount(),
                                                      total,
                                                      amountPaid.toString(), staffFullName, staffID);

                                                  // Add a delay if needed
                                                  Future.delayed(const Duration(seconds: 2));

                                                  // Truncate on_transaction table
                                                  _truncateOnTransaction();

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
                                                            padding:
                                                            const EdgeInsets.all(16.0),
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
                                                                            FontWeight
                                                                                .bold,
                                                                            fontSize: 16)),
                                                                    Text(
                                                                        '₱ ${change.toStringAsFixed(2)}',
                                                                        style:
                                                                        const TextStyle(
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                            16)),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                    const POSMain()), // Replace with your actual Home widget
                                                              );
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
                                  }
                                },
                                child: const Text('Payment'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_onTransaction.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Basket is Empty'),
                                      ),
                                    );
                                  } else {
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
                                                      builder: (context) => const POSMain()),
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
                                  }
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

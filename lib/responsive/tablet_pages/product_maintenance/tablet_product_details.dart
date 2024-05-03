import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../database/database_helper.dart';
import '../../../sidebar_menu/sidebar_menu.dart';

class TabletProductDetails extends StatefulWidget {
  const TabletProductDetails({Key? key}) : super(key: key);

  @override
  _TabletDashboardState createState() => _TabletDashboardState();
}

class _TabletDashboardState extends State<TabletProductDetails> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isDrawerOpen = true;
  List<Map<String, dynamic>> _productsDetails = [];
  List<Map<String, dynamic>> _productTypeList = [];
  List<Map<String, dynamic>> _supplierDetailsList = [];
  bool _isLoading = true;
  XFile? _imageFile;

  late TextEditingController _descriptionController;
  String _productTypeValue = '';
  late TextEditingController _unitCostController;
  late TextEditingController _sellPriceController;
  String _supplierValue = '';
  String _isTaxExemptValue = '';
  String _isDiscountValue = '';
  late TextEditingController _manufacturedDateController;
  late TextEditingController _expirationDateController;
  late TextEditingController _searchCodeController;
  late TextEditingController _quantityController;

  DateTime? _manufacturedDate;
  DateTime? _expirationDate;

  // Method to capture a photo using the device camera
  Future<void> _capturePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50, // Adjust the quality here (0 to 100)
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _uploadPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Adjust the quality here (0 to 100)
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _selectManufacturedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _manufacturedDate = picked;
        _manufacturedDateController.text =
            "${picked.day}/${picked.month}/${picked.year}"; // Update the text field with the selected date
      });
    }
  }

  Future<void> _selectExpirationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _expirationDate = picked;
        _expirationDateController.text =
            "${picked.day}/${picked.month}/${picked.year}"; // Update the text field with the selected date
      });
    }
  }

  void _refreshProductsDetails() async {
    final data = await SQLHelper.getProductsDetails();
    setState(() {
      _productsDetails = data;
      _isLoading = false;
    });
  }

  void _getProductTypesData() async {
    final data = await SQLHelper.getProductTypes();
    setState(() {
      _productTypeList = data;
    });
  }

  void _getSupplierDetailsData() async {
    final data = await SQLHelper.getSupplierDetails();
    setState(() {
      _supplierDetailsList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _descriptionController = TextEditingController();
    _unitCostController = TextEditingController();
    _sellPriceController = TextEditingController();
    _manufacturedDateController = TextEditingController();
    _expirationDateController = TextEditingController();
    _searchCodeController = TextEditingController();
    _quantityController = TextEditingController();
    _refreshProductsDetails();
    _getProductTypesData();
    _getSupplierDetailsData();
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  /// * ADD PRODUCTS CLASS **
  Future<void> _addProductsDetails() async {
    // Convert the image file to bytes
    Uint8List? imageBytes;
    if (_imageFile != null) {
      imageBytes = await _imageFile!.readAsBytes();
    }

    double unitCost = double.parse(_unitCostController.text);
    double sellPrice = double.parse(_sellPriceController.text);

    double profit = sellPrice - unitCost;
    double markup = (profit / unitCost) * 100;

    bool isTaxExempt = false;
    bool isDiscounted = false;

    if (_isTaxExemptValue == '1') {
      isTaxExempt = true;
    }

    if (_isTaxExemptValue == '2') {
      isTaxExempt = false;
    }

    if (_isDiscountValue == '1') {
      isDiscounted = true;
    }

    if (_isDiscountValue == '2') {
      isDiscounted = false;
    }

    int quantity = int.parse(_quantityController.text);

    await SQLHelper.createProductsDetails(
        _descriptionController.text,
        _productTypeValue,
        unitCost,
        sellPrice,
        _supplierValue,
        isTaxExempt,
        isDiscounted,
        _manufacturedDate,
        _expirationDate,
        _searchCodeController.text,
        markup,
        quantity,
        imageBytes);

    _refreshProductsDetails();
    print("..number of items ${_productsDetails.length}");
  }

  /// * UPDATE SUPPLIER DETAILS CLASS **
  Future<void> _updateProductsDetails(int id) async {
    // Convert the image file to bytes
    Uint8List? imageBytes;
    if (_imageFile != null) {
      imageBytes = await _imageFile!.readAsBytes();
    }

    double unitCost = double.parse(_unitCostController.text);
    double sellPrice = double.parse(_sellPriceController.text);

    double profit = sellPrice - unitCost;
    double markup = (profit / unitCost) * 100;

    bool isTaxExempt = false;
    bool isDiscounted = false;

    if (_isTaxExemptValue == '1') {
      isTaxExempt = true;
    }

    if (_isTaxExemptValue == '2') {
      isTaxExempt = false;
    }

    if (_isDiscountValue == '1') {
      isDiscounted = true;
    }

    if (_isDiscountValue == '2') {
      isDiscounted = false;
    }

    int quantity = int.parse(_quantityController.text);

    await SQLHelper.updateProduct(
        id,
        _descriptionController.text,
        _productTypeValue,
        unitCost,
        sellPrice,
        _supplierValue,
        isTaxExempt,
        isDiscounted,
        _manufacturedDate,
        _expirationDate,
        _searchCodeController.text,
        markup,
        quantity,
        imageBytes);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully updated Supplier Details'),
    ));

    _refreshProductsDetails();
  }

  /// * ADD OR UPDATE PRODUCT DIALOG CLASS **
  void addProductsDetailsDialog(BuildContext context, int? id) async {
    if (id != null) {
      final existingProductDetails =
          _productsDetails.firstWhere((element) => element['id'] == id);
      _descriptionController.text = existingProductDetails['description'];
      // _productTypeValue = existingProductDetails['product_type'].toString();
      _unitCostController.text = existingProductDetails['unit_cost'].toString();
      _sellPriceController.text =
          existingProductDetails['sell_price'].toString();
      // _supplierValue = existingProductDetails['supplier'].toString();
      // _isTaxExemptValue = existingProductDetails['is_tax_exempt'].toString();
      // _isDiscountValue = existingProductDetails['is_discount'].toString();
      _manufacturedDateController.text =
          existingProductDetails['manufactured_date'].toString();
      _expirationDateController.text =
          existingProductDetails['expiration_date'].toString();
      _searchCodeController.text =
          existingProductDetails['search_code'].toString();
      _quantityController.text =
          existingProductDetails['ordering_level'].toString();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 200, // Adjust the width to your preference
                      height: 200, // Adjust the height to your preference
                      child: _imageFile != null
                          ? Image.file(
                              File(_imageFile!.path),
                              fit: BoxFit
                                  .cover, // Ensure the image fills the container without stretching
                            )
                          : const Placeholder(), // Placeholder widget if no image is selected
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await _capturePhoto();
                            setState(
                                () {}); // Rebuild the dialog UI after capturing the photo
                          },
                          icon: const Icon(Icons.camera_alt),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () async {
                            await _uploadPhoto();
                            setState(
                                () {}); // Rebuild the dialog UI after capturing the photo
                          },
                          icon: const Icon(Icons.image),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(hintText: 'Product Name'),
                    ),

                    const SizedBox(height: 10),

                    // Product Type Dropdown
                    DropdownButtonFormField<String>(
                      value: _productTypeValue.isNotEmpty
                          ? _productTypeValue
                          : null,
                      hint: const Text('Select Product Type'),
                      items: _productTypeList.map((productType) {
                        return DropdownMenuItem<String>(
                          value: productType['id'].toString(),
                          child: Text(productType['product_type'].toString()),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _productTypeValue = newValue ?? '';
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _unitCostController,
                      decoration: const InputDecoration(hintText: 'Unit Cost'),
                      maxLines: null,
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _sellPriceController,
                      decoration: const InputDecoration(hintText: 'Sell Price'),
                    ),

                    const SizedBox(height: 10),

                    // Supplier Dropdown
                    DropdownButtonFormField<String>(
                      value: _supplierValue.isNotEmpty ? _supplierValue : null,
                      hint: const Text('Select Supplier'),
                      items: _supplierDetailsList.map((supplier) {
                        return DropdownMenuItem<String>(
                          value: supplier['id'].toString(),
                          child: Text(supplier['supplier'].toString()),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _supplierValue = newValue ?? '';
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    // Is Taxed Dropdown
                    DropdownButtonFormField<String>(
                      value: _isTaxExemptValue.isNotEmpty
                          ? _isTaxExemptValue
                          : null,
                      hint: const Text('Is Tax Exempt?'),
                      items: const [
                        DropdownMenuItem<String>(
                          value: '1',
                          child: Text('Yes'),
                        ),
                        DropdownMenuItem<String>(
                          value: '2',
                          child: Text('No'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _isTaxExemptValue = newValue ?? '';
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    // Is Discounted Dropdown
                    DropdownButtonFormField<String>(
                      value:
                          _isDiscountValue.isNotEmpty ? _isDiscountValue : null,
                      hint: const Text('Is Discounted?'),
                      items: const [
                        DropdownMenuItem<String>(
                          value: '1',
                          child: Text('Yes'),
                        ),
                        DropdownMenuItem<String>(
                          value: '2',
                          child: Text('No'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _isDiscountValue = newValue ?? '';
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        _selectManufacturedDate(
                            context); // Call _selectDate method when the button is pressed
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: TextField(
                        controller: _manufacturedDateController,
                        // Assign the TextEditingController to the TextField
                        enabled: false,
                        // Disable editing the text field directly
                        decoration: const InputDecoration(
                          hintText: 'Select Manufactured Date',
                          contentPadding: EdgeInsets.zero, // Remove padding
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        _selectExpirationDate(
                            context); // Call _selectDate method when the button is pressed
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: TextField(
                        controller: _expirationDateController,
                        // Assign the TextEditingController to the TextField
                        enabled: false,
                        // Disable editing the text field directly
                        decoration: const InputDecoration(
                          hintText: 'Select Expiration Date',
                          contentPadding: EdgeInsets.zero, // Remove padding
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: _searchCodeController,
                      decoration:
                          const InputDecoration(hintText: 'Search Code'),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _quantityController,
                      decoration: const InputDecoration(hintText: 'Quantity'),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_descriptionController.text == '' ||
                    _productTypeValue == '' ||
                    _unitCostController.text == '' ||
                    _sellPriceController.text == '' ||
                    _supplierValue == '' ||
                    _isTaxExemptValue == '' ||
                    _isDiscountValue == '' ||
                    _manufacturedDateController.text == '' ||
                    _searchCodeController.text == '' ||
                    _quantityController.text == '') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Missing fields'),
                        content: const Text(
                            'Some required fields are still blank, please check the required fields. Thank you.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Okay'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  if (id == null) {
                    await _addProductsDetails();
                  }

                  if (id != null) {
                    await _updateProductsDetails(id);
                  }

                  _descriptionController.text = '';
                  _productTypeValue = '';
                  _unitCostController.text = '';
                  _sellPriceController.text = '';
                  _supplierValue = '';
                  _isTaxExemptValue = '';
                  _isDiscountValue = '';
                  _manufacturedDateController.text = '';
                  _expirationDateController.text = '';
                  _searchCodeController.text = '';
                  _quantityController.text = '';
                  _imageFile = null;

                  Navigator.of(context).pop();
                }
              },
              child: Text(id == null ? 'Submit' : 'Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// * DELETE PRODUCT CLASS **
  void _deleteProductDetails(int id) async {
    await SQLHelper.deleteProduct(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted supplier'),
    ));
    _refreshProductsDetails();
  }

  /// * DELETE PRODUCT DIALOG CLASS **
  void deleteProductDetailsDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this Product?'),
          actions: [
            TextButton(
              onPressed: () {
                _deleteProductDetails(id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: const Text('PRODUCT DETAILS'),
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
                        child: AspectRatio(
                          aspectRatio: 120 / 9,
                          child: Container(
                            color: Colors.deepPurple[200],
                          ),
                        ),
                      ),

                      /*** ADD PRODUCT DETAILS BUTTON ***/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              /*** ADD PRODUCT DETAILS DIALOG ***/
                              addProductsDetailsDialog(context, null);
                            },
                            child: Container(
                              width: 150,
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Center(
                                child: Text(
                                  "+ Add Product",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      /*** PRODUCT DETAILS LIST ***/
                      Expanded(
                        child: _productsDetails.isNotEmpty
                            ? ListView.builder(
                          itemCount: _productsDetails.length,
                          itemBuilder: (context, index) => Card(
                            color: Colors.white70,
                            margin: const EdgeInsets.all(5),
                            child: ListTile(
                              leading: _productsDetails[index]['image'] != null &&
                                  (_productsDetails[index]['image'] as Uint8List).isNotEmpty
                                  ? Image.memory(
                                _productsDetails[index]['image'],
                                // Assuming 'image' contains the Uint8List image data
                                width: 50, // Adjust as needed
                                height: 50, // Adjust as needed
                                fit: BoxFit.cover,
                              )
                                  : null,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_productsDetails[index]['description']),
                                  Text('Product Code: ${_productsDetails[index]['product_code']}'),
                                ],
                              ),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => addProductsDetailsDialog(context, _productsDetails[index]['id']),
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () => deleteProductDetailsDialog(context, _productsDetails[index]['id']),
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                            : const Center(
                          child: Text("No supplier available."),
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

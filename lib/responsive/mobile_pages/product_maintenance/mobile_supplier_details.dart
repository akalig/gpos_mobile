import 'package:flutter/material.dart';
import 'package:gpos_mobile/database/database_helper.dart';
import '../../../sidebar_menu/sidebar_menu.dart';

class MobileSupplierDetails extends StatefulWidget {
  const MobileSupplierDetails({Key? key}) : super(key: key);

  @override
  _MobileSupplierDetailsState createState() => _MobileSupplierDetailsState();
}

class _MobileSupplierDetailsState extends State<MobileSupplierDetails> {
  List<Map<String, dynamic>> _supplierDetails = [];
  bool _isLoading = true;
  late TextEditingController _supplierController;
  late TextEditingController _supplierAddressController;
  late TextEditingController _contactPersonController;
  late TextEditingController _contactNumberController;

  void _refreshSupplierDetails() async {
    final data = await SQLHelper.getSupplierDetails();
    setState(() {
      _supplierDetails = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _supplierController = TextEditingController();
    _supplierAddressController = TextEditingController();
    _contactPersonController = TextEditingController();
    _contactNumberController = TextEditingController();
    _refreshSupplierDetails();
  }

  @override
  void dispose() {
    _supplierController.dispose();
    _supplierAddressController.dispose();
    _contactPersonController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  /// * ADD SUPPLIER DETAILS CLASS **
  Future<void> _addSupplierDetails() async {
    await SQLHelper.createSupplierDetails(
        _supplierController.text, _supplierAddressController.text, _contactPersonController.text, _contactNumberController.text);
    _refreshSupplierDetails();
    print("..number of items ${_supplierDetails.length}");
  }

  /// * UPDATE SUPPLIER DETAILS CLASS **
  Future<void> _updateSupplierDetails(int id) async {
    await SQLHelper.updateSupplierDetail(
        id, _supplierController.text, _supplierAddressController.text, _contactPersonController.text, _contactNumberController.text);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully updated Supplier Detials'),
    ));
    _refreshSupplierDetails();
  }

  /// * ADD OR UPDATE PRODUCT TYPE DIALOG CLASS **
  void addSupplierDetailsDialog(BuildContext context, int? id) async {
    if (id != null) {
      final existingProductType =
      _supplierDetails.firstWhere((element) => element['id'] == id);
      _supplierController.text = existingProductType['supplier'];
      _supplierAddressController.text = existingProductType['supplier_address'];
      _contactPersonController.text = existingProductType['contact_person'];
      _contactNumberController.text = existingProductType['contact_number'];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Supplier'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _supplierController,
                  decoration: const InputDecoration(hintText: 'Supplier'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _supplierAddressController,
                  decoration: const InputDecoration(hintText: 'Supplier Address'),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _contactPersonController,
                  decoration: const InputDecoration(hintText: 'Contact Person'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _contactNumberController,
                  decoration: const InputDecoration(hintText: 'Contact Number'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (id == null) {
                  await _addSupplierDetails();
                }

                if (id != null) {
                  await _updateSupplierDetails(id);
                }

                _supplierController.text = '';
                _supplierAddressController.text = '';
                _contactPersonController.text = '';
                _contactNumberController.text = '';

                Navigator.of(context).pop();
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

  /// * DELETE SUPPLIER DETAILS CLASS **
  void _deleteSupplierDetails(int id) async {
    await SQLHelper.deleteSupplierDetail(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted supplier'),
    ));
    _refreshSupplierDetails();
  }

  /// * DELETE SUPPLIER DETAILS DIALOG CLASS **
  void deleteSupplierDetailsDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Supplier'),
          content:
          const Text('Are you sure you want to delete this Supplier?'),
          actions: [
            TextButton(
              onPressed: () {
                _deleteSupplierDetails(id);
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
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: const Text('SUPPLIER DETAILS'),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // youtube video
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatio(
                aspectRatio: 110 / 9,
                child: Container(
                  color: Colors.deepPurple[200],
                ),
              ),
            ),

            /*** ADD SUPPLIER DETAILS BUTTON ***/
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    /*** ADD SUPPLIER DETAILS DIALOG ***/
                    addSupplierDetailsDialog(context, null);
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
                        "+ Add Supplier",
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

            /*** SUPPLIER DETAILS LIST ***/
            Expanded(
              child: _supplierDetails.isNotEmpty
                  ? ListView.builder(
                itemCount: _supplierDetails.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.white70,
                  margin: const EdgeInsets.all(5),
                  child: ListTile(
                    title: Text(
                        _supplierDetails[index]['supplier']),
                    subtitle: Text(
                        _supplierDetails[index]['supplier_address']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                addSupplierDetailsDialog(context,
                                    _supplierDetails[index]['id']),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () =>
                                deleteSupplierDetailsDialog(context,
                                    _supplierDetails[index]['id']),
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
      // Use SidebarMenu widget as the drawer
      drawer: const SidebarMenu(),
    );
  }
}
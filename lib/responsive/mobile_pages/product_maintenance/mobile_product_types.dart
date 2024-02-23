import 'package:flutter/material.dart';
import 'package:gpos_mobile/database/dabase_helper.dart';
import '../../../sidebar_menu/sidebar_menu.dart';

class MobileProductTypes extends StatefulWidget {
  const MobileProductTypes({Key? key}) : super(key: key);

  @override
  _MobileProductTypesState createState() => _MobileProductTypesState();
}

class _MobileProductTypesState extends State<MobileProductTypes> {
  List<Map<String, dynamic>> _productTypes = [];
  bool _isLoading = true;
  late TextEditingController _productTypeController;
  late TextEditingController _descriptionController;

  void _refreshProductTypes() async {
    final data = await SQLHelper.getProductTypes();
    setState(() {
      _productTypes = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _productTypeController = TextEditingController();
    _descriptionController = TextEditingController();
    _refreshProductTypes();
  }

  @override
  void dispose() {
    _productTypeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// * ADD PRODUCT TYPE CLASS **
  Future<void> _addProductType() async {
    await SQLHelper.createProductTypes(
        _productTypeController.text, _descriptionController.text);
    _refreshProductTypes();
    print("..number of items ${_productTypes.length}");
  }

  /// * UPDATE PRODUCT TYPE CLASS **
  Future<void> _updateProductType(int id) async {
    await SQLHelper.updateProductType(
        id, _productTypeController.text, _descriptionController.text);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully updated product Type'),
    ));
    _refreshProductTypes();
  }

  /// * ADD OR UPDATE PRODUCT TYPE DIALOG CLASS **
  void addProductTypeDialog(BuildContext context, int? id) async {
    if (id != null) {
      final existingProductType =
      _productTypes.firstWhere((element) => element['id'] == id);
      _productTypeController.text = existingProductType['product_type'];
      _descriptionController.text = existingProductType['description'];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Product Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _productTypeController,
                decoration: const InputDecoration(hintText: 'Product Type'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (id == null) {
                  await _addProductType();
                }

                if (id != null) {
                  await _updateProductType(id);
                }

                _productTypeController.text = '';
                _descriptionController.text = '';

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

  /// * DELETE PRODUCT TYPE CLASS **
  void _deleteProductType(int id) async {
    await SQLHelper.deleteProductType(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted product Type'),
    ));
    _refreshProductTypes();
  }

  /// * DELETE PRODUCT TYPE DIALOG CLASS **
  void deleteProductTypeDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product Type'),
          content:
          const Text('Are you sure you want to delete this Product Type?'),
          actions: [
            TextButton(
              onPressed: () {
                _deleteProductType(id);
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
        title: const Text('PRODUCT TYPES'),
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
                aspectRatio: 120 / 9,
                child: Container(
                  color: Colors.deepPurple[200],
                ),
              ),
            ),

            /*** ADD PRODUCT TYPE BUTTON ***/
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    /*** ADD PRODUCT TYPE DIALOG ***/
                    addProductTypeDialog(context, null);
                  },

                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.all(5),
                    margin:
                    const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        "+ Add Product Type",
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

            // comment section & recommended videos
            /*** PRODUCT TYPES LIST ***/
            Expanded(
              child: _productTypes.isNotEmpty
                  ? ListView.builder(
                itemCount: _productTypes.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.white70,
                  margin: const EdgeInsets.all(5),
                  child: ListTile(
                    title: Text(
                        _productTypes[index]['product_type']),
                    subtitle: Text(
                        _productTypes[index]['description']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                addProductTypeDialog(context,
                                    _productTypes[index]['id']),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () =>
                                deleteProductTypeDialog(context,
                                    _productTypes[index]['id']),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
                  : const Center(
                child: Text("No product types available."),
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
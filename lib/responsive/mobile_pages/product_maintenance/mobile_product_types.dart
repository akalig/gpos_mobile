import 'package:flutter/material.dart';
import '../../../sidebar_menu/sidebar_menu.dart';

class MobileProductTypes extends StatelessWidget {
  const MobileProductTypes({Key? key}) : super(key: key);

  /// * ADD PRODUCT TYPE DIALOG CLASS **
  void showAddProductTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Product Type'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                    hintText: 'Product Type'),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                    hintText: 'Description'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Add your submit logic here
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
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

  /// * EDIT PRODUCT TYPE DIALOG CLASS **
  void editProductTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Product Type'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Product Type'),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(hintText: 'Description'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Add your submit logic here
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
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

  /// * DELETE PRODUCT TYPE DIALOG CLASS **
  void deleteProductTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product Type'),
          content: const Text('Are you sure you want to delete this Product Type?'),
          actions: [
            TextButton(
              onPressed: () {
                // Add your submit logic here
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
                aspectRatio: 110 / 9,
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
                    showAddProductTypeDialog(context);

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
            Expanded(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Product Type')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Action')),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text('Sample Product 1')),
                    const DataCell(Text('Description 1')),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            /*** EDIT PRODUCT TYPE DIALOG ***/
                            editProductTypeDialog(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red,),
                          onPressed: () {
                            /*** DELETE PRODUCT TYPE DIALOG ***/
                            deleteProductTypeDialog(context);
                          },
                        ),
                      ],
                    )),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Sample Product 2')),
                    const DataCell(Text('Description 2')),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            /*** EDIT PRODUCT TYPE DIALOG ***/
                            editProductTypeDialog(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red,),
                          onPressed: () {
                            /*** DELETE PRODUCT TYPE DIALOG ***/
                            deleteProductTypeDialog(context);
                          },
                        ),
                      ],
                    )),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Sample Product 3')),
                    const DataCell(Text('Description 3')),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            /*** EDIT PRODUCT TYPE DIALOG ***/
                            editProductTypeDialog(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red,),
                          onPressed: () {
                            /*** DELETE PRODUCT TYPE DIALOG ***/
                            deleteProductTypeDialog(context);
                          },
                        ),
                      ],
                    )),
                  ]),
                ],
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

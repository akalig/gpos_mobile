import 'package:flutter/material.dart';
import '../../../sidebar_menu/sidebar_menu.dart';

class MobileSupplierDetails extends StatelessWidget {
  const MobileSupplierDetails({Key? key}) : super(key: key);

  /// * ADD SUPPLIER DETAILS DIALOG CLASS **
  void addSupplierDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Supplier'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                    hintText: 'Supplier Name'),
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

  /// * EDIT SUPPLIER DETAILS DIALOG CLASS **
  void editSupplierDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Supplier Details'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Supplier Name'),
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

  /// * DELETE SUPPLIER DETAILS DIALOG CLASS **
  void deleteSupplierDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Supplier'),
          content: const Text('Are you sure you want to delete this Supplier?'),
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
                    addSupplierDetailsDialog(context);

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

            // comment section & recommended videos
            Expanded(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Supplier')),
                  DataColumn(label: Text('Action')),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text('Sample Supplier 1')),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            /*** EDIT SUPPLIER DETAILS DIALOG ***/
                            editSupplierDetailsDialog(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red,),
                          onPressed: () {
                            /*** DELETE SUPPLIER DETAILS DIALOG ***/
                            deleteSupplierDetailsDialog(context);
                          },
                        ),
                      ],
                    )),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Sample Supplier 2')),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            /*** EDIT SUPPLIER DETAILS DIALOG ***/
                            editSupplierDetailsDialog(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red,),
                          onPressed: () {
                            /*** DELETE SUPPLIER DETAILS DIALOG ***/
                            deleteSupplierDetailsDialog(context);
                          },
                        ),
                      ],
                    )),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Sample Supplier 3')),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            /*** EDIT SUPPLIER DETAILS DIALOG ***/
                            editSupplierDetailsDialog(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red,),
                          onPressed: () {
                            /*** DELETE SUPPLIER DETAILS DIALOG ***/
                            deleteSupplierDetailsDialog(context);
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

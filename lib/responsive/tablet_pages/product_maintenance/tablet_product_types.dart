import 'package:flutter/material.dart';
import '../../../sidebar_menu/sidebar_menu.dart';

class TabletProductTypes extends StatefulWidget {
  const TabletProductTypes({Key? key}) : super(key: key);

  @override
  _TabletDashboardState createState() => _TabletDashboardState();
}

class _TabletDashboardState extends State<TabletProductTypes> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isDrawerOpen = true;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: const Text('PRODUCT TYPES'),
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
                              addProductTypeDialog(context);
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

                      /*** PRODUCT TYPES TABLE ***/
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
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
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
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
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
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
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

  /// * ADD PRODUCT TYPE DIALOG CLASS **
  void addProductTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Product Type'),
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

}

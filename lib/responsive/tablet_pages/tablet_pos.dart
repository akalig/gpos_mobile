import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../sidebar_menu/sidebar_menu.dart';

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
  bool _isLoading = true;

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
    _scaffoldKey = GlobalKey<ScaffoldState>();
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

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
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
            icon: _isDrawerOpen ? const Icon(Icons.menu_open) : const Icon(Icons.menu),
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
                            color: Colors.deepPurple[100],
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10.0),
                                  onTap: () {
                                    // Perform search action here
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
                    ],
                  ),
                ),

                // second column
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 300,
                    color: Colors.white60,
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

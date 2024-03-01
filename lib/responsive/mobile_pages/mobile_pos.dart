import 'package:flutter/material.dart';
import '../../sidebar_menu/sidebar_menu.dart';
import 'package:gpos_mobile/database/database_helper.dart';
import 'dart:io';
import 'dart:typed_data';

class MobilePOS extends StatefulWidget {
  const MobilePOS({Key? key}) : super(key: key);

  @override
  _MobilePOSState createState() => _MobilePOSState();
}

class _MobilePOSState extends State<MobilePOS> {
  List<Map<String, dynamic>> _productsDetails = [];
  bool _isLoading = true;

  void _refreshProductsDetails() async {
    final data = await SQLHelper.getProductsDetails();
    setState(() {
      _productsDetails = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshProductsDetails();
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

            // comment section & recommended videos
            /*** PRODUCT DETAILS LIST ***/
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: _productsDetails.length, // Assuming _productsDetails contains your data
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.deepPurple[300],
                      height: 80,
                      width: 80,
                      child: Stack(
                        children: [
                          Image.memory(
                            _productsDetails[index]['image'],
                            // Assuming 'image' contains the Uint8List image data
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
                                  _productsDetails[index]['description'], // Assuming 'description' is a key in your data
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
                                  'Price: ₱${_productsDetails[index]['sell_price'].toString()}', // Assuming 'sell_price' is a key in your data
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
                  );
                },
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

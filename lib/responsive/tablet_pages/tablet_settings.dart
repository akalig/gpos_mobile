import 'package:flutter/material.dart';
import 'package:gpos_mobile/database/database_helper.dart';
import '../../../sidebar_menu/sidebar_menu.dart';

class TabletSettings extends StatefulWidget {
  const TabletSettings({Key? key}) : super(key: key);

  @override
  _TabletDashboardState createState() => _TabletDashboardState();
}

class _TabletDashboardState extends State<TabletSettings> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isDrawerOpen = true;


  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: const Text('SETTINGS'),
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
                ),
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

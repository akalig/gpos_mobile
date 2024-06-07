import 'package:flutter/material.dart';
import '../../../sidebar_menu/sidebar_menu.dart';

class MobileUserDetails extends StatefulWidget {
  const MobileUserDetails({super.key});

  @override
  State<MobileUserDetails> createState() => _MobileUserDetailsState();
}

class _MobileUserDetailsState extends State<MobileUserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: const Text('USER DETAILS'),
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
            // comment section & recommended videos


          ],
        ),
      ),
      // Use SidebarMenu widget as the drawer
      drawer: const SidebarMenu(),
    );
  }
}

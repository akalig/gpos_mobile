import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../database/database_helper.dart';
import '../../sidebar_menu/sidebar_menu.dart';

class MobileDashboard extends StatefulWidget {
  const MobileDashboard({Key? key}) : super(key: key);

  @override
  _MobileDashboardState createState() => _MobileDashboardState();
}

class _MobileDashboardState extends State<MobileDashboard> {
  late Future<List<Map<String, dynamic>>> _salesData;
  late Map<String, Color> _colorMap = {}; // Initialize color map with an empty map

  @override
  void initState() {
    super.initState();
    _salesData = SQLHelper.getSalesProductCountWithDescription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('D A S H B O A R D'),
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
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.3,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _salesData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    // Process the retrieved data and update the PieChart
                    final salesData = snapshot.data!;
                    return _buildPieChart(salesData);
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            // Label for Pie Chart
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _salesData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final salesData = snapshot.data!;
                    return ListView.builder(
                      itemCount: salesData.length,
                      itemBuilder: (context, index) {
                        final description = salesData[index]['description'] as String;
                        final color = _getColorForProduct(description); // Get color from map
                        return _buildLabel(description, color);
                      },
                    );
                  }
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

  Color _getColorForProduct(String productName) {
    // Check if color is already assigned to the product, if not generate and assign a new color
    if (!_colorMap.containsKey(productName)) {
      _colorMap[productName] = _getRandomColor();
    }
    return _colorMap[productName]!;
  }

  Widget _buildLabel(String productName, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(productName),
        ],
      ),
    );
  }

  Widget _buildPieChart(List<Map<String, dynamic>> salesData) {
    final List<PieChartSectionData> sections = [];

    // Process the sales data to create PieChartSectionData
    for (final sale in salesData) {
      final int count = sale['count'];
      final description = sale['description'] as String;
      final color = _getColorForProduct(description); // Get color from map

      final section = PieChartSectionData(
        value: count.toDouble(),
        title: '$count', // Include count in the title
        showTitle: true, // Show the title
        radius: 70,
        color: color,
        titleStyle: const TextStyle(
          fontSize: 16, // Adjust the font size as needed
          fontWeight: FontWeight.bold, // Add bold font weight
          color: Colors.white, // Set the text color
        ),
      );
      sections.add(section);
    }

    return PieChart(
      PieChartData(
        sections: sections,
      ),
    );
  }


  Color _getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }
}

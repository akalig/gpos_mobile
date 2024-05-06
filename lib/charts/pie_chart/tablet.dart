import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../database/database_helper.dart';

class PieChartWidgetTablet extends StatefulWidget {
  const PieChartWidgetTablet({Key? key}) : super(key: key);

  @override
  _PieChartWidgetTabletState createState() => _PieChartWidgetTabletState();
}

class _PieChartWidgetTabletState extends State<PieChartWidgetTablet> {
  late Future<List<Map<String, dynamic>>> _salesData;
  late Map<String, Color> _colorMap =
      {}; // Initialize color map with an empty map

  @override
  void initState() {
    super.initState();
    _salesData = SQLHelper.getSalesProductCountWithDescription();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.deepPurple)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.5,
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

          // Label for Pie Chart
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.3,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _salesData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final salesData = snapshot.data!;
                  return ListView.builder(
                    itemCount: salesData.length,
                    itemBuilder: (context, index) {
                      final description =
                          salesData[index]['description'] as String;
                      final color = _getColorForProduct(
                          description); // Get color from map
                      return _buildLabel(description, color);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
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

  Color _getColorForProduct(String productName) {
    // Check if color is already assigned to the product, if not generate and assign a new color
    if (!_colorMap.containsKey(productName)) {
      _colorMap[productName] = _getRandomColor();
    }
    return _colorMap[productName]!;
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
        title: '$count',
        // Include count in the title
        showTitle: true,
        // Show the title
        radius: 75,
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

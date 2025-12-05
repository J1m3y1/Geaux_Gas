import 'dart:math' show sin, cos, sqrt, atan2, pi;
import 'package:flutter/material.dart';
import 'package:gas_app_project_dev/services/globals.dart';

const lightBackground = Color(0xFFF3FFF7);
const lightCard = Color(0xFFE6FFF0);
const lightBorder = Color(0xFFB7F5D4);
const lightText = Color(0xFF2F855A);
const lightAccent = Color(0xFF68D391);

const darkBackground = Color(0xFF121212);
const darkCard = Color(0xFF1E1E1E);
const darkBorder = Color(0xFF2A2A2A);
const darkTextPrimary = Color(0xFFE0E0E0);
const darkTextSecondary = Color(0xFFA0A0A0);
const darkAccent = Color(0xFF34D399);

class FilterSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApply;
  final Map<String, dynamic> currentFilters;

  const FilterSheet({
    required this.onApply,
    required this.currentFilters,
    super.key,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late double maxDistance;
  String sortOption = 'distance_asc';

  //Loads data before UI is built
  @override
  void initState() {
    super.initState();
    maxDistance = widget.currentFilters['maxDistance'] ?? 10;
    sortOption = widget.currentFilters['sort'] ?? 'distance_asc';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkModeNotifier.value;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? darkCard : lightCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        border: Border.all(color: isDark ? darkBorder : lightBorder, width: 2),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Filters',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? darkTextPrimary : lightText,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Max Distance: ${maxDistance.toStringAsFixed(1)} miles',
            style: TextStyle(
              color: isDark ? darkTextPrimary : Colors.black87,
              fontSize: 15,
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: isDark ? darkAccent : lightAccent,
              inactiveTrackColor: (isDark ? darkBorder : lightBorder),
              thumbColor: isDark ? darkAccent : lightAccent,
              overlayColor: (isDark ? darkAccent : lightAccent),
              trackHeight: 4,
            ),
            child: Slider(
              value: maxDistance,
              min: 1,
              max: 25,
              divisions: 24,
              onChanged: (val) => setState(() => maxDistance = val),
            ),
          ),

          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Sort By:",
              style: TextStyle(
                fontSize: 16,
                color: isDark ? darkTextPrimary : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? darkBackground : lightBackground,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isDark ? darkBorder : lightBorder,
                width: 2,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: sortOption,
                isExpanded: true,
                dropdownColor: isDark ? darkCard : lightCard,
                items: const [
                  DropdownMenuItem(
                    value: 'price_asc',
                    child: Text('Price: Low → High'),
                  ),
                  DropdownMenuItem(
                    value: 'price_desc',
                    child: Text('Price: High → Low'),
                  ),
                  DropdownMenuItem(
                    value: 'distance_asc',
                    child: Text('Distance: Closest First'),
                  ),
                  DropdownMenuItem(
                    value: 'distance_desc',
                    child: Text('Distance: Farthest First'),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => sortOption = value ?? sortOption),
              ),
            ),
          ),

          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'maxDistance': maxDistance,
                  'sort': sortOption,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? darkAccent : lightAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class StationFilter {
  //Calculates distance of user and gas station using longtitude and latitude
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371;

    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degToRad(double deg) => deg * (pi / 180);
}

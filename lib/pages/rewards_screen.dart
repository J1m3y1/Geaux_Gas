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

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkModeNotifier.value;

    return Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? darkCard : lightCard,
        elevation: 0,
        title: Text(
          "Rewards",
          style: TextStyle(
            color: isDark ? darkTextPrimary : lightText,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: isDark ? darkTextPrimary : lightText),
      ),

      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? darkCard : lightCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? darkBorder : lightBorder,
              width: 2,
            ),
          ),
          child: Text(
            "Rewards coming soon...",
            style: TextStyle(
              fontSize: 20,
              color: isDark ? darkTextPrimary : lightText,
            ),
          ),
        ),
      ),
    );
  }
}

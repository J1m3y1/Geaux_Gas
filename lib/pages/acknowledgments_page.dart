import 'package:flutter/material.dart';
import 'package:gas_app_project_dev/services/globals.dart';

const lightBackground = Color(0xFFF3FFF7);
const lightCard = Color(0xFFE6FFF0);
const lightBorder = Color(0xFFB7F5D4);
const lightText = Color(0xFF2F855A);

const darkBackground = Color(0xFF121212);
const darkCard = Color(0xFF1E1E1E);
const darkBorder = Color(0xFF2A2A2A);
const darkTextPrimary = Color(0xFFE0E0E0);
const darkTextSecondary = Color(0xFFA0A0A0);

class AcknowledgmentsPage extends StatelessWidget {
  const AcknowledgmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return Scaffold(
          backgroundColor: isDark ? darkBackground : lightBackground,

          appBar: AppBar(
            backgroundColor: isDark ? darkCard : lightCard,
            elevation: 1,
            title: Text(
              'Acknowledgments',
              style: TextStyle(
                color: isDark ? darkTextPrimary : lightText,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(
              color: isDark ? darkTextPrimary : lightText,
            ),
          ),

          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? darkCard : lightCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? darkBorder : lightBorder,
                  width: 2,
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acknowledgments',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: isDark ? darkTextPrimary : lightText,
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    'We would like to thank everyone who made this app possible.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: isDark ? darkTextSecondary : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    "Thank you to Daniel Donze and LSU for providing the class."
                    "\n\nContributors:"
                    "\n• Cardin Tran"
                    "\n• Jimmy Rubio-Gonzalez"
                    "\n• Hoa Ho"
                    "\n• Emari Landry"
                    "\n• Matthew Duffy",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: isDark ? darkTextPrimary : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

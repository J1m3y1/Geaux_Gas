import 'package:flutter/material.dart';
import 'package:gas_app_project_dev/services/globals.dart';
import 'package:gas_app_project_dev/assets/app_colors.dart';

class AcknowledgmentsPage extends StatelessWidget {
  const AcknowledgmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        return Scaffold(
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,

          appBar: AppBar(
            backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
            elevation: 1,
            title: Text(
              'Acknowledgments',
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightText,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightText,
            ),
          ),

          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
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
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightText,
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    'We would like to thank everyone who made this app possible.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : Colors.black87,
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
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : Colors.black87,
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

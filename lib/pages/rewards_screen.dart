import 'package:flutter/material.dart';
import 'package:gas_app_project_dev/services/globals.dart';
import 'package:gas_app_project_dev/assets/app_colors.dart';

// placeholder for rewards
class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkModeNotifier.value;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      // top nav bar
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        elevation: 0,
        title: Text(
          "Rewards",
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightText,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightText,
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 2,
            ),
          ),
          child: Text(
            "Rewards coming soon...",
            style: TextStyle(
              fontSize: 20,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightText,
            ),
          ),
        ),
      ),
    );
  }
}

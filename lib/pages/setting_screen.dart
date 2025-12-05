import 'package:flutter/material.dart';
import 'package:gas_app_project_dev/pages/acknowledgments_page.dart';
import 'package:gas_app_project_dev/pages/feedback_page.dart';
import 'package:gas_app_project_dev/pages/signup_login_page.dart';
import 'package:gas_app_project_dev/services/auth.dart';
import 'package:gas_app_project_dev/services/globals.dart';
import 'package:gas_app_project_dev/pages/contributor_page.dart';
import 'package:gas_app_project_dev/assets/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String textSize = 'Medium';

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
              'Settings',
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightText,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightText,
            ),
          ),

          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 20,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: SwitchListTile(
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightText,
                    ),
                  ),
                  secondary: Icon(
                    Icons.dark_mode,
                    color: isDark
                        ? AppColors.darkAccent
                        : AppColors.lightAccent,
                  ),
                  value: isDark,
                  onChanged: (newValue) {
                    isDarkModeNotifier.value = newValue;
                  },
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Support/About',
                style: TextStyle(
                  fontSize: 20,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              _buildSettingsTile(
                isDark: isDark,
                title: "Become A Contributor",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContributorPage(),
                    ),
                  );
                },
              ),

              _buildSettingsTile(
                isDark: isDark,
                title: "Feedback",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeedbackPage(),
                    ),
                  );
                },
              ),

              _buildSettingsTile(
                isDark: isDark,
                title: "Acknowledgments",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AcknowledgmentsPage(),
                    ),
                  );
                },
              ),

              _buildSettingsTile(
                isDark: isDark,
                title: "Sign Out",
                onTap: () async {
                  try {
                    await Auth().signOut();
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to sign out. Try again.'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsTile({
    required bool isDark,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightText,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightText,
        ),
        onTap: onTap,
      ),
    );
  }
}

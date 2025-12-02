import 'package:flutter/material.dart';
import 'package:gas_app_project_dev/pages/acknowledgments_page.dart';
import 'package:gas_app_project_dev/pages/feedback_page.dart';
import 'package:gas_app_project_dev/pages/signup_login_page.dart';
import 'package:gas_app_project_dev/services/auth.dart';
import 'package:gas_app_project_dev/services/globals.dart';
import 'package:gas_app_project_dev/pages/contributor_page.dart';

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
          backgroundColor: isDark ? darkBackground : lightBackground,
          appBar: AppBar(
            backgroundColor: isDark ? darkCard : lightCard,
            elevation: 1,
            title: Text(
              'Settings',
              style: TextStyle(
                color: isDark ? darkTextPrimary : lightText,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(
              color: isDark ? darkTextPrimary : lightText,
            ),
          ),

          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 20,
                  color: isDark ? darkTextPrimary : lightText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? darkCard : lightCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? darkBorder : lightBorder),
                ),
                child: SwitchListTile(
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: isDark ? darkTextPrimary : lightText,
                    ),
                  ),
                  secondary: Icon(
                    Icons.dark_mode,
                    color: isDark ? darkAccent : lightAccent,
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
                  color: isDark ? darkTextPrimary : lightText,
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
        color: isDark ? darkCard : lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? darkBorder : lightBorder),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? darkTextPrimary : lightText,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDark ? darkTextSecondary : lightText,
        ),
        onTap: onTap,
      ),
    );
  }
}

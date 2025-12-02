import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class ContributorPage extends StatefulWidget {
  const ContributorPage({super.key});

  @override
  State<ContributorPage> createState() => _ContributorPageState();
}

class _ContributorPageState extends State<ContributorPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.clear();
    emailController.clear();
    reasonController.clear();
  }

  void saveContributor() async {
    await FirebaseFirestore.instance.collection('contributors').add({
      'name': nameController.text,
      'email': emailController.text,
      'reason': reasonController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

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
              'Contributor',
              style: TextStyle(
                color: isDark ? darkTextPrimary : lightText,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(
              color: isDark ? darkTextPrimary : lightText,
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Become a Contributor',
                  style: TextStyle(
                    fontSize: 22,
                    color: isDark ? darkTextPrimary : lightText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _buildThemedInput(
                  isDark: isDark,
                  controller: nameController,
                  label: 'Name',
                ),
                const SizedBox(height: 20),

                _buildThemedInput(
                  isDark: isDark,
                  controller: emailController,
                  label: 'Email',
                ),
                const SizedBox(height: 20),

                _buildThemedInput(
                  isDark: isDark,
                  controller: reasonController,
                  label: 'Reason to become a contributor',
                  isLarge: true,
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      saveContributor();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.send_outlined),
                    label: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? darkAccent : lightAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemedInput({
    required bool isDark,
    required TextEditingController controller,
    required String label,
    bool isLarge = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? darkCard : lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? darkBorder : lightBorder, width: 2),
      ),
      child: TextField(
        controller: controller,
        maxLines: isLarge ? 10 : 1,
        style: TextStyle(color: isDark ? darkTextPrimary : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDark ? darkTextSecondary : lightText),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

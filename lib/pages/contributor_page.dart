import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_app_project_dev/services/globals.dart';
import 'package:gas_app_project_dev/assets/app_colors.dart';

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
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,

          appBar: AppBar(
            backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
            elevation: 1,
            title: Text(
              'Contributor',
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightText,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightText,
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
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightText,
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
                      backgroundColor: isDark
                          ? AppColors.darkAccent
                          : AppColors.lightAccent,
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
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 2,
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: isLarge ? 10 : 1,
        style: TextStyle(
          color: isDark ? AppColors.darkTextPrimary : Colors.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightText,
          ),
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

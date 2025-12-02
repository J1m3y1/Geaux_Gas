import 'package:cloud_firestore/cloud_firestore.dart';
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

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController feedback = TextEditingController();

  @override
  void initState() {
    super.initState();
    feedback.clear();
  }

  void saveResponse() async {
    await FirebaseFirestore.instance.collection('feedback').add({
      'feedback': feedback.text,
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
              'Feedback',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We’d love to hear your feedback!',
                  style: TextStyle(
                    fontSize: 20,
                    color: isDark ? darkTextPrimary : lightText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? darkCard : lightCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? darkBorder : lightBorder,
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: feedback,
                    maxLines: 10,
                    style: TextStyle(
                      color: isDark ? darkTextPrimary : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your feedback here',
                      hintStyle: TextStyle(
                        color: isDark ? darkTextSecondary : Colors.grey[600],
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      saveResponse();
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
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We’d love to hear your feedback!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: feedback,
              decoration: InputDecoration(
                hintText: 'Enter your feedback here',
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                saveResponse();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.send_outlined),
              label: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

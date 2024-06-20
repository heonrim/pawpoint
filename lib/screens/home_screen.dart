import 'package:flutter/material.dart';
import 'diary/diary_list_screen.dart';
// Import other screens here

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DiaryListScreen()),
                );
              },
              child: const Text('View Diaries'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to health record screen
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const HealthRecordScreen()),
                // );
              },
              child: const Text('View Health Records'),
            ),
            // You can add more buttons to navigate to other feature screens
          ],
        ),
      ),
    );
  }
}
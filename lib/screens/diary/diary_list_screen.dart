import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/diary_entry.dart';
import '../../services/diary_service.dart';
import '../../services/auth_service.dart';
import 'diary_edit_screen.dart';

class DiaryListScreen extends StatelessWidget {
  const DiaryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final diaryService = DiaryService();
    final authService = Provider.of<AuthService>(context);
    final currentUser = authService.getCurrentUser();

    if (currentUser == null) {
      // 處理未登入狀況
      return const Center(child: Text('User not logged in'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary List'),
      ),
      body: StreamBuilder<List<DiaryEntry>>(
        stream: diaryService.getDiaryEntries(currentUser.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = snapshot.data!;

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];

              return ListTile(
                title: Text(entry.title),
                subtitle: Text(entry.content),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DiaryEditScreen(entry: entry),
                  ));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const DiaryEditScreen(),
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
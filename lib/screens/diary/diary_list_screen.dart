import 'package:flutter/material.dart';
import '../../models/diary_entry.dart';
import '../../services/diary_service.dart';
import 'diary_edit_screen.dart';

class DiaryListScreen extends StatelessWidget {
  const DiaryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final diaryService = DiaryService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary List'),
      ),
      body: StreamBuilder<List<DiaryEntry>>(
        stream: diaryService.getDiaryEntries('user_id'), // 替換為實際的用戶ID
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
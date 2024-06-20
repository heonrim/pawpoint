import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/diary_entry.dart';
import '../../services/diary_service.dart';

class DiaryEditScreen extends StatefulWidget {
  final DiaryEntry? entry;

  const DiaryEditScreen({super.key, this.entry}); // 使用超參數

  @override
  DiaryEditScreenState createState() => DiaryEditScreenState(); // 改為公開類
}

class DiaryEditScreenState extends State<DiaryEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  bool _isPublic = false;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _title = widget.entry!.title;
      _content = widget.entry!.content;
      _isPublic = widget.entry!.isPublic;
    }
  }

  @override
  Widget build(BuildContext context) {
    final diaryService = Provider.of<DiaryService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'New Entry' : 'Edit Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'), // 使用 const
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _content,
                decoration: const InputDecoration(labelText: 'Content'), // 使用 const
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
                onSaved: (value) {
                  _content = value!;
                },
              ),
              SwitchListTile(
                title: const Text('Public'), // 使用 const
                value: _isPublic,
                onChanged: (value) {
                  setState(() {
                    _isPublic = value;
                  });
                },
              ),
              const SizedBox(height: 16.0), // 使用 const
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final newEntry = DiaryEntry(
                      id: widget.entry?.id ?? diaryService.getNewEntryId(),
                      uid: 'user_id', // 替換為實際的用戶ID
                      title: _title,
                      content: _content,
                      imageUrl: '', // 替換為實際的圖片URL
                      createdAt: DateTime.now(),
                      isPublic: _isPublic,
                    );

                    if (widget.entry == null) {
                      await diaryService.addDiaryEntry(newEntry);
                    } else {
                      await diaryService.updateDiaryEntry(newEntry);
                    }

                    if (!mounted) return;
                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.entry == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryEntry {
  final String id;
  final String uid;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime createdAt;
  final bool isPublic;

  DiaryEntry({
    required this.id,
    required this.uid,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    required this.isPublic,
  });

  factory DiaryEntry.fromMap(Map<String, dynamic> data, String documentId) {
    return DiaryEntry(
      id: documentId,
      uid: data['uid'],
      title: data['title'],
      content: data['content'],
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isPublic: data['isPublic'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'isPublic': isPublic,
    };
  }
}
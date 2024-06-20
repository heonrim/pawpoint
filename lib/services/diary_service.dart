import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/diary_entry.dart';

class DiaryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDiaryEntry(DiaryEntry entry) async {
    await _firestore.collection('diaries').doc(entry.id).set(entry.toMap());
  }

  Future<void> updateDiaryEntry(DiaryEntry entry) async {
    await _firestore.collection('diaries').doc(entry.id).update(entry.toMap());
  }

  Future<void> deleteDiaryEntry(String id) async {
    await _firestore.collection('diaries').doc(id).delete();
  }

  Stream<List<DiaryEntry>> getDiaryEntries(String uid) {
    return _firestore.collection('diaries').where('uid', isEqualTo: uid).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => DiaryEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  String getNewEntryId() {
    return _firestore.collection('diaries').doc().id;
  }
}
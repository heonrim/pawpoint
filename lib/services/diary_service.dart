import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/diary_entry.dart';

class DiaryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  Future<void> addDiaryEntry(DiaryEntry entry) async {
    try {
      await _firestore.collection('diaries').doc(entry.id).set(entry.toMap());
      _logger.i('Diary entry added successfully: ${entry.id}');
    } catch (e) {
      _logger.e('Error adding diary entry: $e');
    }
  }

  Future<void> updateDiaryEntry(DiaryEntry entry) async {
    try {
      await _firestore.collection('diaries').doc(entry.id).update(entry.toMap());
      _logger.i('Diary entry updated successfully: ${entry.id}');
    } catch (e) {
      _logger.e('Error updating diary entry: $e');
    }
  }

  Future<void> deleteDiaryEntry(String id) async {
    try {
      await _firestore.collection('diaries').doc(id).delete();
      _logger.i('Diary entry deleted successfully: $id');
    } catch (e) {
      _logger.e('Error deleting diary entry: $e');
    }
  }

  Stream<List<DiaryEntry>> getDiaryEntries(String uid) {
    _logger.i('Fetching diary entries for user: $uid');
    return _firestore.collection('diaries').where('uid', isEqualTo: uid).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => DiaryEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  String getNewEntryId() {
    return _firestore.collection('diaries').doc().id;
  }
}
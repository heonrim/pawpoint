import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserInfo(String uid, String name, String email) async {
    UserModel user = UserModel(uid: uid, name: name, email: email);
    try {
      await _firestore.collection('users').doc(uid).set(user.toMap());
    } catch (e) {
      print('Error saving user info: $e');
      // 錯誤處理
    }
  }
}

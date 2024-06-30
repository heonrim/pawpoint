import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return false; // 用戶取消了登錄
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // 檢查是否是第一次登入並保存用戶信息到 Firestore
      bool isFirstTime = await isFirstTimeLogin();
      if (isFirstTime) {
        await saveUserInfo(userCredential.user!, name: userCredential.user!.displayName!);
      }
      print('Is first time login: $isFirstTime (auth_service.dart A)');
      return isFirstTime;
    } catch (error) {
      print('Google sign-in error: $error (auth_service.dart A)');
      return false; // 錯誤處理
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<bool> isFirstTimeLogin() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      bool isFirstTime = !userDoc.exists;
      print('Is first time login: $isFirstTime (auth_servise B)');  // 在終端機中打印訊息
      return isFirstTime;
    }
    return false;
  }

  Future<void> saveUserInfo(User user, {required String name, String? photoURL}) async {
    await _firestore.collection('users').doc(user.uid).set({
      'name': name,
      'email': user.email,
      'photoURL': photoURL ?? user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> uploadProfilePicture(File imageFile) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in or session expired');
    }
    Reference storageRef = _storage.ref().child('profile_pictures/${user.uid}.jpg');
    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    await _firestore.collection('users').doc(user.uid).update({'photoURL': downloadURL});
    return downloadURL;
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
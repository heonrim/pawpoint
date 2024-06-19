import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PawPoint'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await _authService.signInWithGoogle();
              // 登入成功後導航到主頁面
              if (FirebaseAuth.instance.currentUser != null) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            } catch (error) {
              print('Login error: $error');
              // 顯示錯誤消息給用戶
            }
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
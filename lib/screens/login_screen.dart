import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PawPoint'), // 使用 const
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await _authService.signInWithGoogle();
              if (!mounted) return;
              // 登錄成功後導航到主頁面
              Navigator.pushReplacementNamed(context, '/home');
            } catch (error) {
              // 使用更合適的日誌記錄方法
              debugPrint('Login error: $error');
              if (!mounted) return;
              // 顯示錯誤消息給用戶
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Login error: $error'),
                ),
              );
            }
          },
          child: const Text('Sign in with Google'), // 使用 const
        ),
      ),
    );
  }
}
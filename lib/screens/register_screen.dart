import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    User? user = authService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'), // 使用 const
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'), // 使用 const
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              if (user != null)
                TextFormField(
                  initialValue: user.email,
                  decoration: const InputDecoration(labelText: 'Email'), // 使用 const
                  enabled: false,
                ),
              const SizedBox(height: 16.0), // 使用 const
              if (_imageFile != null)
                Image.file(_imageFile!, height: 150, width: 150),
              TextButton(
                onPressed: _pickImage,
                child: const Text('Upload Profile Picture'), // 使用 const
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    String? photoURL;
                    if (_imageFile != null) {
                      photoURL = await authService.uploadProfilePicture(_imageFile!);
                    }

                    await authService.saveUserInfo(user!, name: _name, photoURL: photoURL);
                    if (!mounted) return;
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                child: const Text('Register'), // 使用 const
              ),
            ],
          ),
        ),
      ),
    );
  }
}
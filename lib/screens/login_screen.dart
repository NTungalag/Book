import 'package:diplom/screens/login_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Нэвтрэх хэсэг',
          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(12),
        child: LoginForm(),
      ),
    );
  }
}

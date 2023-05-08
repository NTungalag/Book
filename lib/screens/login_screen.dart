import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/repositories/authontication_repository.dart';
import 'package:diplom/repositories/book_repository.dart';
import 'package:diplom/screens/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Нэвтрэх'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(12),
        child: LoginForm(),
      ),
    );
  }
}

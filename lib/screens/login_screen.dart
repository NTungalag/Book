import 'package:diplom/blocs/login_bloc.dart';
import 'package:diplom/repositories/authontication_repository.dart';
import 'package:diplom/repositories/book_repository.dart';
import 'package:diplom/repositories/user_repository.dart';
import 'package:diplom/screens/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Нэвтрэх'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) => LoginBloc(
            bookRepository: RepositoryProvider.of<BookRepository>(context),
            authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
            // userRepository: RepositoryProvider.of<UserRepository>(context),
          ),
          child: const LoginForm(),
        ),
      ),
    );
  }
}

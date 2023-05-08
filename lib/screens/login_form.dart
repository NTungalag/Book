import 'package:diplom/blocs/authentication_bloc.dart';
import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/events/authontication_event.dart';
import 'package:diplom/events/user_events.dart';
import 'package:diplom/repositories/authontication_repository.dart';
import 'package:diplom/screens/register.dart';
import 'package:diplom/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email = '', password = '';
  late bool _passwordVisible;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.status == UserStatus.FAILURE) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
        if (state.status == UserStatus.VALID) {
          context
              .read<AuthenticationBloc>()
              .add(const AuthStatusChanged(AuthenticationStatus.authenticated));
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email_rounded),
                  labelText: 'Цахим хаяг',
                ),
                onChanged: (value) => email = value,
                onSaved: (String? value) {},
                validator: (String? value) {
                  return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                      onTap: () => setState(() {
                            _passwordVisible = !_passwordVisible;
                          }),
                      child: Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility)),
                  icon: const Icon(Icons.security_update),
                  labelText: 'Нууц үг',
                ),
                onChanged: (value) => password = value,
                onSaved: (String? value) {},
                validator: (String? value) {
                  return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                },
                obscureText: _passwordVisible,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () => context.read<UserBloc>().add(LoginSubmitted(password, email)),
                  child: const Text('Нэвтрэх')),
              GestureDetector(
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const Register())),
                  child: const Text('Бүртгүүлэх'))
            ],
          ),
        ),
      ),
    );
  }
}

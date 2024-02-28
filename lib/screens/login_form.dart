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
    _passwordVisible = true;
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
                  icon: Icon(
                    Icons.email_rounded,
                    color: Colors.blueGrey,
                  ),
                  labelText: 'Цахим хаяг',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueGrey,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 153, 136, 205),
                    ),
                  ),
                ),
                onChanged: (value) => setState(() {
                  email = value;
                }),
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
                      child: Icon(
                        _passwordVisible ? Icons.visibility_off : Icons.visibility,
                        color: Colors.blueGrey,
                      )),
                  icon: const Icon(
                    Icons.security_update,
                    color: Colors.blueGrey,
                  ),
                  labelText: 'Нууц үг',
                  labelStyle: const TextStyle(color: Colors.blueGrey),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 153, 136, 205),
                    ),
                  ),
                ),
                onChanged: (value) => setState(() {
                  password = value;
                }),
                onSaved: (String? value) {},
                validator: (String? value) {
                  return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                },
                obscureText: _passwordVisible,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(email == '' || password == ''
                          ? Colors.black12
                          : const Color.fromARGB(255, 153, 136, 205)),
                    ),
                    onPressed: () => email.trim() == '' || password.trim() == ''
                        ? ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Нэр эсвэл нууц үг хоосон байна')),
                          )
                        : context.read<UserBloc>().add(LoginSubmitted(password, email)),
                    child: email == '' || password.isEmpty
                        ? const Text('Нэвтрэх',
                            style: TextStyle(color: Color.fromARGB(255, 153, 136, 205)))
                        : Text(
                            'Нэвтрэх',
                            style: TextStyle(color: Colors.white),
                          ),
                  )),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                  child: const Text(
                    'Бүртгүүлэх ',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

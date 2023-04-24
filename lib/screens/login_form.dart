import 'package:diplom/blocs/authentication_bloc.dart';
import 'package:diplom/blocs/login_bloc.dart';
import 'package:diplom/events/authontication_event.dart';
import 'package:diplom/events/login_events.dart';
import 'package:diplom/repositories/authontication_repository.dart';
import 'package:diplom/states/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email = '', password = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.FAILURE) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
        if (state.status == LoginStatus.VALID) {
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
              // _UsernameInput(),
              // const Padding(padding: EdgeInsets.all(12)),
              // _PasswordInput(),
              // const Padding(padding: EdgeInsets.all(12)),
              // _LoginButton(),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'What do people call you?',
                  labelText: 'Name *',
                ),
                onChanged: (value) => email = value,
                onSaved: (String? value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                validator: (String? value) {
                  return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'What do people call you?',
                  labelText: 'Name *',
                ),
                onChanged: (value) => password = value,
                onSaved: (String? value) {},
                validator: (String? value) {
                  return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
                },
              ),
              ElevatedButton(
                  onPressed: () => context.read<LoginBloc>().add(LoginSubmitted(password, email)),
                  child: const Text('Press'))
            ],
          ),
        ),
      ),
    );
  }
}

// class _UsernameInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginBloc, LoginState>(
//       buildWhen: (previous, current) => previous.username != current.username,
//       builder: (context, state) {
//         return TextField(
//           key: const Key('loginForm_usernameInput_textField'),
//           onChanged: (username) => context.read<LoginBloc>().add(LoginUsernameChanged(username)),
//           decoration: const InputDecoration(
//             labelText: 'username',
//             errorText: /*state.username.invalid ? 'invalid username' :*/ null,
//           ),
//         );
//       },
//     );
//   }
// }

// class _PasswordInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginBloc, LoginState>(
//       buildWhen: (previous, current) => previous.password != current.password,
//       builder: (context, state) {
//         return TextField(
//           key: const Key('loginForm_passwordInput_textField'),
//           onChanged: (password) => context.read<LoginBloc>().add(LoginPasswordChanged(password)),
//           obscureText: true,
//           decoration: const InputDecoration(
//             labelText: 'password',
//             errorText: /* state.password.invalid ? 'invalid password' :*/ null,
//           ),
//         );
//       },
//     );
//   }
// }

// class _LoginButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginBloc, LoginState>(
//       buildWhen: (previous, current) => previous.username != current.username,
//       builder: (context, state) {
//         return state.status == LoginStatus.VALID
//             ? const CircularProgressIndicator()
//             : ElevatedButton(
//                 key: const Key('loginForm_continue_raisedButton'),
//                 onPressed: state.status == LoginStatus.INVALID
//                     ? () {
//                         // context.read<LoginBloc>().add(const LoginSubmitted());
//                       }
//                     : null,
//                 child: const Text('Login'),
//               );
//       },
//     );
//   }
// }

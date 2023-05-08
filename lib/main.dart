import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:diplom/blocs/authentication_bloc.dart';
import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/repositories/authontication_repository.dart';
import 'package:diplom/repositories/book_repository.dart';
import 'package:diplom/screens/login_screen.dart';
import 'package:diplom/screens/splashScreen.dart';
import 'package:diplom/states/authentication_state.dart';
import 'package:diplom/tabs.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  late final BookRepository _bookRepository;

  @override
  void initState() {
    super.initState();
    _authenticationRepository = AuthenticationRepository();
    _bookRepository = BookRepository();
  }

  @override
  void dispose() {
    _authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
            create: (context) => AuthenticationRepository()),
        RepositoryProvider<BookRepository>(create: (context) => BookRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
              create: (BuildContext context) =>
                  AuthenticationBloc(authenticationRepository: _authenticationRepository)),
          BlocProvider<UserBloc>(
              create: (BuildContext context) => UserBloc(
                    authenticationRepository: _authenticationRepository,
                    bookRepository: _bookRepository,
                  )),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  _navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (BuildContext context) => const Tabs()),
                    ModalRoute.withName('/Home'),
                  );
                  break;
                case AuthenticationStatus.unauthenticated:
                  _navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
                    ModalRoute.withName('/Login'),
                  );
                  break;
                case AuthenticationStatus.unknown:
                  break;
              }
            },
            child: child,
          );
        },
        onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => const SplashPage()));
  }
}

import 'package:diplom/repositories/authontication_repository.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();
}

class AuthStatusChanged extends AuthenticationEvent {
  const AuthStatusChanged(this.status);

  final AuthenticationStatus status;
}

class AuthLogoutRequested extends AuthenticationEvent {}

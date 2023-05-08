import 'package:diplom/repositories/authontication_repository.dart';
import 'package:equatable/equatable.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.name = '',
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated() : this._(status: AuthenticationStatus.authenticated);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  // final User user;
  final String? name;

  @override
  List<Object> get props => [status];
}

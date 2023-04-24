import 'package:diplom/blocs/login_bloc.dart';
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.INVALID,
    this.username = 'h',
    this.password = 'jk',
    this.books = const [],
  });
  final LoginStatus status;

  final String username;
  final String password;
  final List books;

  LoginState copyWith({
    LoginStatus? status,
    String? username,
    String? password,
    List? books,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      books: books ?? this.books,
    );
  }

  @override
  List<Object> get props => [status, username, password, books];
}

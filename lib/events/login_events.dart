import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

// class LoginUsernameChanged extends LoginEvent {
//   const LoginUsernameChanged(this.username);

//   final String username;

//   @override
//   List<Object> get props => [username];
// }

class GetUserBooks extends LoginEvent {}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted(this.password, this.username);
  final String password;
  final String username;

  @override
  List<Object> get props => [password, username];
}

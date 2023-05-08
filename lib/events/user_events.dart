import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUserBooks extends UserEvent {
  final int userId;

  const GetUserBooks(this.userId);
}

class LoginSubmitted extends UserEvent {
  const LoginSubmitted(this.password, this.username);
  final String password;
  final String username;

  @override
  List<Object> get props => [password, username];
}

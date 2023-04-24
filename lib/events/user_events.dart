import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

// class UserUsernameChanged extends UserEvent {
//   const UserUsernameChanged(this.username);

//   final String username;

//   @override
//   List<Object> get props => [username];
// }

class GetUserBooks extends UserEvent {}

class UserSubmitted extends UserEvent {
  const UserSubmitted(this.password, this.username);
  final String password;
  final String username;

  @override
  List<Object> get props => [password, username];
}

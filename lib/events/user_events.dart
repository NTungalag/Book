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

class GetUserChatRooms extends UserEvent {
  final int userId;

  const GetUserChatRooms(this.userId);
}

class CreateChatroom extends UserEvent {
  final int userOne;
  final String? name;
  final String? description;
  final int userTwo;

  const CreateChatroom({required this.userOne, this.name, this.description, required this.userTwo});
}

class UpdateUser extends UserEvent {
  final int userId;

  final String? name;
  final String? email;
  final String? image;

  const UpdateUser({required this.userId, this.name, this.email, this.image});
}

class LoginSubmitted extends UserEvent {
  const LoginSubmitted(this.password, this.username);
  final String password;
  final String username;

  @override
  List<Object> get props => [password, username];
}

class Register extends UserEvent {
  const Register(this.password, this.username, this.email);
  final String password;
  final String username;
  final String email;
}

class LogOut extends UserEvent {
  const LogOut(this.userId);
  final int userId;
}

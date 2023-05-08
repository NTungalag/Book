import 'package:equatable/equatable.dart';

import 'package:diplom/blocs/user_bloc.dart';
import 'package:diplom/models/user_model.dart';

class UserState extends Equatable {
  const UserState({
    this.status = UserStatus.INVALID,
    this.books = const [],
    this.user = User.empty,
  });

  final UserStatus status;
  final List books;
  final User? user;

  UserState copyWith({
    UserStatus? status,
    List? books,
    User? user,
  }) {
    return UserState(
      status: status ?? this.status,
      books: books ?? this.books,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      books,
      user!,
    ];
  }
}

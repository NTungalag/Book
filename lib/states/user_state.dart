import 'package:diplom/blocs/user_bloc.dart';
import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  const UserState({
    this.status = UserStatus.INVALID,
    this.books = const [],
  });
  final UserStatus status;

  final List books;

  UserState copyWith({
    UserStatus? status,
    List? books,
  }) {
    return UserState(
      status: status ?? this.status,
      books: books ?? this.books,
    );
  }

  @override
  List<Object> get props => [status, books];
}

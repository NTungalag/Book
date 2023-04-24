import 'package:diplom/events/user_events.dart';

import 'package:diplom/repositories/authontication_repository.dart';

import 'package:diplom/repositories/user_repository.dart';
import 'package:diplom/states/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum UserStatus { CHECK, LOGGEDOUT, VALID, INVALID, FAILURE }

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required UserRepository userRepository,

    // required BookRepository bookRepository,
  })  : _userRepository = userRepository,

        // _bookRepository = bookRepository,
        super(const UserState()) {
    // on<UserSubmitted>(_onSubmitted);
    // on<SetUser>(_onSetUser);
  }

  final UserRepository _userRepository;

  // final BookRepository _bookRepository;

  // Future<void> _onSubmitted(
  //   UserSubmitted event,
  //   Emitter<UserState> emit,
  // ) async {
  //   print(event.password);
  //   emit(state.copyWith(status: UserStatus.CHECK));
  //   try {
  //     var user = await _authRepository.User(username: event.username, password: event.password);
  //     if (user.id != null) {
  //       GetUserBooks();
  //     }

  //     emit(state.copyWith(status: UserStatus.VALID, username: user.name));
  //   } catch (_) {
  //     emit(state.copyWith(status: UserStatus.FAILURE));
  //   }
  // }

  Future<void> _onGetBooks(
    GetUserBooks event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.CHECK));
    try {
      // var books = await _bookRepository.getBooks();

      // emit(state.copyWith(status: UserStatus.VALID, books: books));
    } catch (_) {
      emit(state.copyWith(status: UserStatus.FAILURE));
    }
  }
}

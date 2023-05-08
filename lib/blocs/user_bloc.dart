import 'package:diplom/events/user_events.dart';
import 'package:diplom/models/user_model.dart';
import 'package:diplom/repositories/authontication_repository.dart';
import 'package:diplom/repositories/book_repository.dart';
import 'package:diplom/states/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum UserStatus { CHECK, LOGGEDOUT, VALID, INVALID, FAILURE }

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required AuthenticationRepository authenticationRepository,
    required BookRepository bookRepository,
  })  : _authRepository = authenticationRepository,
        _bookRepository = bookRepository,
        super(UserState()) {
    on<LoginSubmitted>(_onSubmitted);
    on<GetUserBooks>(_onGetBooks);
  }

  final AuthenticationRepository _authRepository;
  final BookRepository _bookRepository;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.CHECK));
    try {
      var user = await _authRepository.logIn(username: event.username, password: event.password);

      if (user.id != null) {
        GetUserBooks(user.id);
      }
      print(user);

      emit(state.copyWith(status: UserStatus.VALID, user: user));
    } catch (_) {
      emit(state.copyWith(status: UserStatus.FAILURE));
    }
  }

  Future<void> _onGetBooks(
    GetUserBooks event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.CHECK));
    try {
      var books = await _bookRepository.getBooks(userId: event.userId);
      print(books.length);
      emit(state.copyWith(status: UserStatus.VALID, books: books));
    } catch (_) {
      emit(state.copyWith(status: UserStatus.FAILURE));
    }
  }
}

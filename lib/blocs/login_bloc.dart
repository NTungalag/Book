import 'package:diplom/events/login_events.dart';
import 'package:diplom/repositories/authontication_repository.dart';
import 'package:diplom/repositories/book_repository.dart';
import 'package:diplom/repositories/user_repository.dart';
import 'package:diplom/states/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum LoginStatus { CHECK, LOGGEDOUT, VALID, INVALID, FAILURE }

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
    required BookRepository bookRepository,

    // required BookRepository bookRepository,
  })  : _authRepository = authenticationRepository,
        _bookRepository = bookRepository,
        super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
    on<GetUserBooks>(_onGetBooks);
  }

  final AuthenticationRepository _authRepository;
  final BookRepository _bookRepository;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    print(event.password);
    emit(state.copyWith(status: LoginStatus.CHECK));
    try {
      var user = await _authRepository.logIn(username: event.username, password: event.password);
      if (user.id != null) {
        GetUserBooks();
      }

      emit(state.copyWith(status: LoginStatus.VALID, username: user.name));
    } catch (_) {
      emit(state.copyWith(status: LoginStatus.FAILURE));
    }
  }

  Future<void> _onGetBooks(
    GetUserBooks event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.CHECK));
    try {
      var books = await _bookRepository.getBooks();

      emit(state.copyWith(status: LoginStatus.VALID, books: books));
    } catch (_) {
      emit(state.copyWith(status: LoginStatus.FAILURE));
    }
  }
}

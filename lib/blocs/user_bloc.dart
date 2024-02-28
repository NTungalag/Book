import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:diplom/events/user_events.dart';
import 'package:diplom/repositories/authontication_repository.dart';
import 'package:diplom/repositories/book_repository.dart';
import 'package:diplom/repositories/user_repository.dart';
import 'package:diplom/states/user_state.dart';

enum UserStatus { CHECK, LOGGEDOUT, VALID, INVALID, FAILURE, updated, success, loading }

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required AuthenticationRepository authenticationRepository,
    required BookRepository bookRepository,
    required UserRepository userRepository,
  })  : _authRepository = authenticationRepository,
        _bookRepository = bookRepository,
        _userRepository = userRepository,
        super(const UserState()) {
    on<LoginSubmitted>(_onSubmitted);
    on<GetUserBooks>(_onGetBooks);
    on<GetUserChatRooms>(_onGetChatRooms);
    on<CreateChatroom>(_onCreateChatRoom);
    on<UpdateUser>(_onUpdateUser);
    on<Register>(_onRegister);
    on<LogOut>(_onLogOut);
  }

  final AuthenticationRepository _authRepository;
  final BookRepository _bookRepository;
  final UserRepository _userRepository;

  Future<void> _onRegister(
    Register event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.loading));

    try {
      var user = await _authRepository.register(
          username: event.username, password: event.password, email: event.email);

      if (user.id != null) {
        GetUserBooks(user.id);
        GetUserChatRooms(user.id);
      }

      emit(state.copyWith(status: UserStatus.success, user: user));
    } catch (_) {
      emit(state.copyWith(status: UserStatus.FAILURE));
    }
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.loading));

    try {
      var user = await _authRepository.logIn(username: event.username, password: event.password);
      print(user);
      if (user.id != null) {
        GetUserBooks(user.id);
        GetUserChatRooms(user.id);
      }

      emit(state.copyWith(status: UserStatus.VALID, user: user));
    } catch (_) {
      print(_.toString());
      emit(state.copyWith(status: UserStatus.FAILURE));
    }
  }

  Future<void> _onLogOut(
    LogOut event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.loading));

    try {
      var user = await _authRepository.logOut(
        userId: event.userId,
      );

      emit(state.copyWith(status: UserStatus.LOGGEDOUT));
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

      emit(state.copyWith(status: UserStatus.VALID, books: books));
    } catch (_) {
      emit(state.copyWith(status: UserStatus.FAILURE));
    }
  }

  Future<void> _onGetChatRooms(
    GetUserChatRooms event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.CHECK));
    try {
      var chatRooms = await _userRepository.getChatRooms(userId: event.userId);

      emit(state.copyWith(status: UserStatus.VALID, chatRooms: chatRooms));
    } catch (_) {
      emit(state.copyWith(status: UserStatus.FAILURE));
    }
  }

  Future<void> _onCreateChatRoom(
    CreateChatroom event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.CHECK));
    try {
      var chatRoom = await _userRepository.createChatroom(
          name: event.name!,
          userOne: event.userOne,
          userTwo: event.userTwo,
          description: event.description!);

      emit(state.copyWith(status: UserStatus.success, chatRoomLast: chatRoom));
    } catch (_) {
      emit(state.copyWith(status: UserStatus.FAILURE));
    }
  }

  Future<void> _onUpdateUser(
    UpdateUser event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.CHECK));
    try {
      var user = await _userRepository.updateUser(
          userId: event.userId, name: event.name, image: event.image, email: event.email);
      emit(state.copyWith(status: UserStatus.VALID, user: user));
    } catch (_) {
      emit(state.copyWith(status: UserStatus.FAILURE));
    }
  }
}

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:diplom/events/authontication_event.dart';
import 'package:diplom/repositories/authontication_repository.dart';
import 'package:diplom/states/authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    _authStatusSubscription = _authRepository.status.listen(
      (status) => add(AuthStatusChanged(status)),
    );
  }

  final AuthenticationRepository _authRepository;
  late StreamSubscription<AuthenticationStatus> _authStatusSubscription;

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthStatusChanged(
    AuthStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        // final user = await _tryGetUser();
        return emit(
            // user != null
            //     ?
            AuthenticationState.authenticated()
            // : const AuthenticationState.unauthenticated(),
            );
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
    }
  }

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    // _authRepository.logOut();
  }
}

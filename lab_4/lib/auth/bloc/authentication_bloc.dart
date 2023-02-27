import 'package:bloc/bloc.dart';
import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthService authService,
  })  : _authService = authService,
       super(AuthenticationInitial()){
    on<LoginWithEmailAndPasswordEvent>(_mapLoginWithEmailAndPasswordEvent);
    on<CreateAccountEvent>(_mapCreateAccountEvent);
    on<UserAlreadyLoggedInEvent>(_mapUserAlreadyLoggedInEvent);
    on<UserSignOutEvent>(_mapUserSignOutEvent);
  }

  final AuthService _authService;
  late UserEntity user;


  Future<void> _mapLoginWithEmailAndPasswordEvent(
      LoginWithEmailAndPasswordEvent event,
      Emitter<AuthenticationState> emit,
      ) async {
    try {
      UserEntity? user = await _authService.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      this.user = user;
      emit(SuccessState(user));
    } catch (e) {
      emit(
        ErrorState(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _mapCreateAccountEvent(
      CreateAccountEvent event,
      Emitter<AuthenticationState> emit,
      ) async {
    try {
      UserEntity? user = await _authService.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      this.user = user;
      emit(SuccessState(user));
    } catch (e) {
      emit(
        ErrorState(
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _mapUserAlreadyLoggedInEvent(
      UserAlreadyLoggedInEvent event,
      Emitter<AuthenticationState> emit,
      ) async {

    UserEntity? user = await _authService.getLoggedInUser();
    return user.isAnonymous
      ? emit(AuthenticationInitial())
      : emit(SuccessState(user));
  }

  Future<void> _mapUserSignOutEvent(
    UserSignOutEvent event,
    Emitter<AuthenticationState> emit
  ) async {
    await _authService.signOut().whenComplete(() => emit(AuthenticationInitial()));
  }
}

import 'package:bloc/bloc.dart';
import 'package:auth/auth.dart';

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
  }

  final AuthService _authService;

  Future<void> _mapLoginWithEmailAndPasswordEvent(
      LoginWithEmailAndPasswordEvent event,
      Emitter<AuthenticationState> emit,
      ) async {
    try {
      await _authService.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(SuccessState());
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
      await _authService.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(SuccessState());
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
    return await _authService.isUserLoggedIn()
    ? emit(SuccessState())
    : emit(AuthenticationInitial());
  }
}
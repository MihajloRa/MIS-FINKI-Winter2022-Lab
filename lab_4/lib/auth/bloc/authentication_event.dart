part of 'authentication_bloc.dart';

class AuthenticationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginWithEmailAndPasswordEvent extends AuthenticationEvent {
  final String email;
  final String password;

  LoginWithEmailAndPasswordEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email];
}

class UserAlreadyLoggedInEvent extends AuthenticationEvent {}

class CreateAccountEvent extends AuthenticationEvent {
  final String email;
  final String password;

  CreateAccountEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email];
}

class UserSignOutEvent extends AuthenticationEvent {

}


part of 'authentication_bloc.dart';

abstract class AuthenticationState {
  AuthenticationState({required this.user});
  UserEntity user;

  String get email => user.email;
}

class AuthenticationInitial extends AuthenticationState {
  AuthenticationInitial() : super(user: UserEntity.empty());
}

class SuccessState extends AuthenticationState {
  SuccessState(UserEntity user)
      : super(user: user);
}

class ErrorState extends AuthenticationState {
  final String message;

  ErrorState({required this.message}) : super(user: UserEntity.empty());
}
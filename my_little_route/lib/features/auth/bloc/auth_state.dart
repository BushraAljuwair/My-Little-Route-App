part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class TogglePasswordVisibilityState extends AuthState {
  final bool isPasswordVisible;

  TogglePasswordVisibilityState({required this.isPasswordVisible});
}

class StateState extends AuthState {}

class LogInStatate extends AuthState {}
class SignUpSatate extends AuthState {}

class LoadingStatate extends AuthState {}

class ErrorStatate extends AuthState {
  final String msg;

  ErrorStatate({required this.msg});
}

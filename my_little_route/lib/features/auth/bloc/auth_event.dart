part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class TogglePasswordVisibilityEvent extends AuthEvent {}
class SignUPEvent extends AuthEvent {}
class LogInEvent extends AuthEvent {}

part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class TogglePasswordVisibilityState extends AuthState{
  final bool isPasswordVisible;

  TogglePasswordVisibilityState({required this.isPasswordVisible});
}
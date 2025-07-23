part of 'add_admin_bloc.dart';

@immutable
sealed class AddAdminState {}

final class AddAdminInitial extends AddAdminState {}
final class TogglePasswordVisibilityState extends AddAdminState {
  final bool isPasswordVisible;

  TogglePasswordVisibilityState({required this.isPasswordVisible});
}


final class SuccsessState extends AddAdminState {}
final class ErrorInAddAdimnState extends AddAdminState {
  final String message;

  ErrorInAddAdimnState({required this.message});
}
 
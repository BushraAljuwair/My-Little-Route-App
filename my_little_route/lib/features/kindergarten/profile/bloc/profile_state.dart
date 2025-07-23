part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class SuccessState extends ProfileState {}

final class ErrorState extends ProfileState {
  final String message;

  ErrorState({required this.message});
}

final class LoadingState extends ProfileState {}

final class SuccessLogOutState extends ProfileState {}

final class ErrorLogOutState extends ProfileState {
  final String message;

  ErrorLogOutState({required this.message});
}

final class ProfileUpdatedState extends ProfileState {
 final UserModel user;

  ProfileUpdatedState({required this.user});
}
final class ProfileErrorState extends ProfileState {
    final String message;

  ProfileErrorState({required this.message});
}


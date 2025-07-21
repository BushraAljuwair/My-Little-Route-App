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

part of 'student_bloc.dart';

@immutable
sealed class StudentState {}

final class StudentInitial extends StudentState {}

final class LoadingState extends StudentState {}
final class ErrorState extends StudentState {
  final String message;

  ErrorState({required this.message}); 
}
final class SuccessState extends StudentState {}

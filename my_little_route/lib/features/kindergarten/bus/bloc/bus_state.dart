part of 'bus_bloc.dart';

@immutable
sealed class BusState {}

final class BusInitial extends BusState {}

class SuccessState extends BusState {}

class ErrorState extends BusState {
  final String message;

  ErrorState({required this.message});
}
class LoadingState extends BusState {}

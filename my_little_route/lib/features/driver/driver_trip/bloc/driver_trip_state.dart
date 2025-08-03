part of 'driver_trip_bloc.dart';

@immutable
abstract class DriverTripState {}

class DriverTripInitial extends DriverTripState {}

class SuccessState extends DriverTripState {}

class ErrorState extends DriverTripState {
  final String messge;

  ErrorState({required this.messge});
}

class SuccessAddNewTripState extends DriverTripState {}

class LoadingState extends DriverTripState {}

class TripEndedState extends DriverTripState {}

class MapDataReadyState extends DriverTripState {}

class SucssesGetTripState extends DriverTripState {}

class ErrorGetTripState extends DriverTripState {
  final String messge;

  ErrorGetTripState({required this.messge});
}

class SucssesCreateReturnTripState extends DriverTripState {}

class ErrorCreateReturnTripState extends DriverTripState {
  final String messge;

  ErrorCreateReturnTripState({required this.messge});
}


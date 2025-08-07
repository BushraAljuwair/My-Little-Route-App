part of 'trip_navigtion_bloc.dart';

@immutable
sealed class TripNavigtionState {}

final class TripNavigtionInitial extends TripNavigtionState {}

class LoadingState extends TripNavigtionState {}

class SucssesGetTripState extends TripNavigtionState {}

class ErrorGetInfoState extends TripNavigtionState {
  final String messge;

  ErrorGetInfoState({required this.messge});
}

class LoadingPickUpState extends TripNavigtionState {}

class SucssesPickUpState extends TripNavigtionState {}

class ErrorPickUpState extends TripNavigtionState {
  final String messge;

  ErrorPickUpState({required this.messge});
}

class TripEndedState extends TripNavigtionState {}

class MapDataReadyState extends TripNavigtionState {}

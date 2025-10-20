part of 'tracking_bloc.dart';

@immutable
sealed class  TrackingState {}

final class TrayTrackingInitial extends TrackingState {}
final class SucssesState extends TrackingState {}
final class LoadingState extends TrackingState {}
final class ErrorState extends TrackingState {
  final String message;

  ErrorState({required this.message});
}

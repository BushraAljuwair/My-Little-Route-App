part of 'tray_tracking_bloc.dart';

@immutable
sealed class TrayTrackingState {}

final class TrayTrackingInitial extends TrayTrackingState {}
final class SucssesState extends TrayTrackingState {}
final class LoadingState extends TrayTrackingState {}
final class ErrorState extends TrayTrackingState {
  final String message;

  ErrorState({required this.message});
}

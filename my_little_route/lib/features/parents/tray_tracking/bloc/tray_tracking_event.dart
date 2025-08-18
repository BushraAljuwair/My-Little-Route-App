part of 'tray_tracking_bloc.dart';

@immutable
sealed class TrayTrackingEvent {}

class SetInitValuesEvent extends TrayTrackingEvent {}

class MapCreatedEvent extends TrayTrackingEvent {
  final GoogleMapController controller;

  MapCreatedEvent({required this.controller});
}

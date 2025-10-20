part of 'tracking_bloc.dart';

@immutable
sealed class  TrackingEvent {}

class SetInitValuesEvent extends  TrackingEvent {}

class MapCreatedEvent extends  TrackingEvent {
  final GoogleMapController controller;

  MapCreatedEvent({required this.controller});
}

class BusLocationUpdatedEvent extends  TrackingEvent {
  final LatLng newLocation;
  BusLocationUpdatedEvent(this.newLocation);
}
 
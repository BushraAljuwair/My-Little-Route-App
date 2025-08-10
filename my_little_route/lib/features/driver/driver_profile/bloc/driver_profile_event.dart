part of 'driver_profile_bloc.dart';

@immutable
sealed class DriverProfileEvent {}

class GetDriverBusInfoEvent extends DriverProfileEvent {}

class UpdateUserInfoEvent extends DriverProfileEvent {}

class UpdateMarkerLocationEvent extends DriverProfileEvent {
  final LatLng newLocation;

  UpdateMarkerLocationEvent({required this.newLocation});
}

class UpdateDriverLocationEvent extends DriverProfileEvent {}

class LogOutEvent extends DriverProfileEvent {}





class LoadInitialImageEvent extends DriverProfileEvent {}

class GetImageFromGalleryEvent extends DriverProfileEvent {}

class UploadImageEvent extends DriverProfileEvent {
  final File image;
  UploadImageEvent({required this.image});
}

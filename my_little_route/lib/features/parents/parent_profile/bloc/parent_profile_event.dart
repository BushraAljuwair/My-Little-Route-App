part of 'parent_profile_bloc.dart';

@immutable
sealed class ParentProfileEvent {}

class  GetParentAndChildInfoEvent extends  ParentProfileEvent {}



 
class GetImageFromGalleryEvent extends ParentProfileEvent {}

class UploadImageEvent extends ParentProfileEvent {
  final File image;
  UploadImageEvent({required this.image});
}

class LogOutEvent extends ParentProfileEvent {}
class UpdateUserInfoEvent extends ParentProfileEvent {}
class UpdateMarkerLocationEvent extends ParentProfileEvent {
  final LatLng newLocation;

  UpdateMarkerLocationEvent({required this.newLocation});
}
class UpdateLocationEvent extends ParentProfileEvent {}

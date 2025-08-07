part of 'trip_navigtion_bloc.dart';

@immutable
sealed class TripNavigtionEvent {}

class GetDriverAndStudentsEvent extends TripNavigtionEvent {}

class CreatePickUpEvent extends TripNavigtionEvent {}
class UpdateStudentStatusEvent extends TripNavigtionEvent {
  final bool newStatus;
  final StudentsModel student;
  final TripStudentsModel tripStudent;
   final String tripType;

  UpdateStudentStatusEvent({
    required this.newStatus,
    required this.student,
    required this.tripStudent,
    required this.tripType,
  });
}

class UpdateMapDataEvent extends TripNavigtionEvent {
  final Position? position;

  UpdateMapDataEvent({this.position});
}

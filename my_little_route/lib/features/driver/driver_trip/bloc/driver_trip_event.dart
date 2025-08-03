part of 'driver_trip_bloc.dart';

@immutable
sealed class DriverTripEvent {}

class GetDriverAndStudentsEvent extends DriverTripEvent {}

class CreateTripEvent extends DriverTripEvent {}

class EndTripEvent extends DriverTripEvent {}

class UpdateMapDataEvent extends DriverTripEvent {}

class GetTripEvent extends DriverTripEvent {}

class CreateReturnTripEvent extends DriverTripEvent {}

class UpdateStudentStatusEvent extends DriverTripEvent {
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

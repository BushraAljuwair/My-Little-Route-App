part of 'driver_profile_bloc.dart';

@immutable
sealed class DriverProfileState {}

final class DriverProfileInitial extends DriverProfileState {}

final class GetDriverBusInfoState extends DriverProfileState {}

final class SuccessState extends DriverProfileState {}

final class LoadingState extends DriverProfileState {}

final class ErorrState extends DriverProfileState {
  final String message;

  ErorrState({required this.message});
}

final class ErorrUpdateLocationState extends DriverProfileState {
  final String message;

  ErorrUpdateLocationState({required this.message});
}

final class SuccessStatesignOut extends DriverProfileState {}

final class ErrorsignOut extends DriverProfileState {
  final String message;

  ErrorsignOut({required this.message});
}

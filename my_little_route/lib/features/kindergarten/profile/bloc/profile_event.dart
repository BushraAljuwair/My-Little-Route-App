part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class GetUserEvent extends ProfileEvent {}

class AddAdminEvent extends ProfileEvent {}

class LogoutEvent extends ProfileEvent {}

class DeleteAccountEvent extends ProfileEvent {}

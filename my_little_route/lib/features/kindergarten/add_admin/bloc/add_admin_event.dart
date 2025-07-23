part of 'add_admin_bloc.dart';

@immutable
sealed class AddAdminEvent {}

class TogglePasswordVisibilityEvent extends AddAdminEvent {}

class AddNewAdminEvent extends AddAdminEvent {}

part of 'parent_home_bloc.dart';

@immutable
sealed class ParentHomeState {}

final class ParentHomeInitial extends ParentHomeState {}

final class ParentErrorState extends ParentHomeState {
  final String message;

  ParentErrorState({required this.message});
}

final class SucssesState extends ParentHomeState {}

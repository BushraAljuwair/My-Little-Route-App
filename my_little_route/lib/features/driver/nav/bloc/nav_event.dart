part of 'nav_bloc.dart';

@immutable
sealed class NavEvent {}

class ChangeScreenDriverEvent extends NavEvent {
  final int index;

  ChangeScreenDriverEvent({required this.index});
}
 
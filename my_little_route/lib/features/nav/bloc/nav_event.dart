part of 'nav_bloc.dart';

@immutable
sealed class NavEvent {}

class ChangeScreenEvent extends NavEvent {
  final int index;

  ChangeScreenEvent({required this.index});
}
 
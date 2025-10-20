part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}
final class SucssesState extends NotificationState {}

final class ErrorNotificationState extends NotificationState {
  final String message;

  ErrorNotificationState({required this.message});
}

 
// final class NotificationsLoadedState extends NotificationState {
//   final List<NotificationsModel> notifcation;

//   NotificationsLoadedState(this.notifcation);
// }

part of 'track_bus_bloc.dart';

@immutable
sealed class TrackBusState {}

// الحالة الأولية عند بداية تشغيل التطبيق
final class TrackBusInitial extends TrackBusState {}

// حالة التحميل، تُظهر مؤشر التحميل
final class TrackBusLoading extends TrackBusState {}

// حالة الاكتمال، تُظهر الخريطة بعد تحميل كل شيء
final class TrackBusLoaded extends TrackBusState {}

// حالة خاصة لتحديث موقع المستخدم
final class TrackBusLocationUpdated extends TrackBusState {
  final LocationData? locationData;
  TrackBusLocationUpdated(this.locationData);
}

// حالة الخطأ، تُظهر رسالة خطأ
final class TrackBusError extends TrackBusState {
  final String message;
  TrackBusError({required this.message});
}

final class ErrorState extends TrackBusState {
  final String message;
  ErrorState({required this.message});
}

final class SuccessState extends TrackBusState {}

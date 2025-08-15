part of 'track_bus_bloc.dart';

@immutable
sealed class TrackBusEvent {}

// حدث واحد للتحميل الأولي لكل البيانات
class LoadInitialDataEvent extends TrackBusEvent {}

// حدث لجلب المسار، يُرسل بعد تهيئة الخريطة
class GetPloyLineEvent extends TrackBusEvent {}

// حدث لتحديث الموقع، يُرسل بشكل مستمر من الـ Stream
class LocationUpdatedEvent extends TrackBusEvent {
  final LocationData locationData;
  LocationUpdatedEvent(this.locationData);
}

 
 
// هذا الحدث الجديد يتم إطلاقه بواسطة الـ Timer لتحريك الباص
class MoveBusEvent extends TrackBusEvent {}
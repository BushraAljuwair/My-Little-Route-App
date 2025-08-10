 
part of 'get_image_bloc.dart';

@immutable
abstract class GetImageEvent {}

// حدث جديد لتحميل الصورة الأولية عند بدء التطبيق
class LoadInitialImageEvent extends GetImageEvent {}

// حدث لاختيار الصورة من المعرض
class GetImageFromGalleryEvent extends GetImageEvent {}

// حدث لرفع الصورة بعد اختيارها
class UploadImageEvent extends GetImageEvent {
  final File image;
  UploadImageEvent({required this.image});
}


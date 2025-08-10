 // get_image/bloc/get_image_state.dart
// يجب أن يكون هذا الملف جزءًا من bloc
part of 'get_image_bloc.dart';

@immutable
sealed class GetImageState {}

final class GetImageInitial extends GetImageState {}

final class SucssesGetImage extends GetImageState {
  final File imageFile;
  SucssesGetImage({required this.imageFile});
}

final class ErrorGetImage extends GetImageState {
  final String message;
  ErrorGetImage({required this.message});
}

final class UploadingImageState extends GetImageState {}

final class ImageUploadedState extends GetImageState {
  final String imageUrl;
  ImageUploadedState({required this.imageUrl});
}
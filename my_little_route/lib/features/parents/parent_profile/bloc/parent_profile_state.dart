part of 'parent_profile_bloc.dart';

@immutable
sealed class ParentProfileState {}

final class ParentProfileInitial extends ParentProfileState {}

final class SuccessState extends ParentProfileState {}
final class ErrorState  extends ParentProfileState {
  final String message;

  ErrorState({required this.message});
}
final class LoadingState extends ParentProfileState {}




final class ErorrUpdateLocationState extends ParentProfileState {
  final String message;

  ErorrUpdateLocationState({required this.message});
}

final class SuccessStatesignOut extends ParentProfileState {}

final class ErrorsignOut extends ParentProfileState {
  final String message;

  ErrorsignOut({required this.message});
}

final class SucssesGetImage extends ParentProfileState {
  final File imageFile;
  SucssesGetImage({required this.imageFile});
}

final class ErrorGetImage extends ParentProfileState {
  final String message;
  ErrorGetImage({required this.message});
}

final class UploadingImageState extends ParentProfileState {}

final class ImageUploadedState extends ParentProfileState {
  final String imageUrl;
  ImageUploadedState({required this.imageUrl});
}

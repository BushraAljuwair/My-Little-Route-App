import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/data_layer/auth_layer.dart';
import 'package:my_little_route/data_layer/auth_service_layer.dart';
import 'package:my_little_route/models/student/students_models.dart';
import 'package:my_little_route/models/user/user_model.dart';
import 'package:my_little_route/utilities/helper/updae_user_email.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'parent_profile_event.dart';
part 'parent_profile_state.dart';

class ParentProfileBloc extends Bloc<ParentProfileEvent, ParentProfileState> {
  final appGetit = GetIt.I.get<AppDataLayer>();
  final authLayerGetit = GetIt.I.get<AuthLayer>();
  final authServiceLGetit = GetIt.I.get<AuthServiceLayer>();
  List<StudentsModel>? childern;
  List<UserModel>? drivers;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  final formKey = GlobalKey<FormState>();

  GoogleMapController? controller;

  var marker = HashSet<Marker>();
  LatLng? newPArentHouse;
  LatLng? cureentParentHouse;

  File? image;
  String? imageUrl;
  ParentProfileBloc() : super(ParentProfileInitial()) {
    on<ParentProfileEvent>((event, emit) {});
    on<GetParentAndChildInfoEvent>(getParentAndChildInfoMethod);

    on<UpdateUserInfoEvent>(updateUserInfoMethd);

    on<UpdateMarkerLocationEvent>(onUpdateMarkerLocation);
    on<GetImageFromGalleryEvent>(_getImageFromGalleryMethod);
    on<UploadImageEvent>(_uploadImageMethod);
    on<LogOutEvent>(logOutMethod);
    on<UpdateLocationEvent>(updateDriverLocationMethod);
  }

  FutureOr<void> updateDriverLocationMethod(
    UpdateLocationEvent event,
    Emitter<ParentProfileState> emit,
  ) {
    try {
      log("1111111111111111111");
      appGetit.updateHuseLocation(
        id: appGetit.user!.id!,
        newLocation: cureentParentHouse!,
      );
      if (childern != null) {
        for (var child in childern!) {
          appGetit.updateHuseLocation(
            id: child.id!,
            newLocation: cureentParentHouse!,
            isChild: true,
          );
          child.latitude = cureentParentHouse!.latitude;
        }
      }

      log("444444444444444444");
    } catch (e) {
      log("88888888888888");

      emit(ErorrUpdateLocationState(message: e.toString()));
    }
  }

  FutureOr<void> getParentAndChildInfoMethod(
    GetParentAndChildInfoEvent event,
    Emitter<ParentProfileState> emit,
  ) async {
    try {
      emit(LoadingState());
      if (appGetit.user == null) {
        await appGetit.getUser(id: authServiceLGetit.currentUser!.id);
      }
      cureentParentHouse = LatLng(
        appGetit.user!.latitude!,
        appGetit.user!.longitude!,
      );
      marker = HashSet<Marker>();
      marker.add(
        Marker(
          markerId: MarkerId("YourHome"),
          position: cureentParentHouse!,
          infoWindow: InfoWindow(title: "YourHome"),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      childern = await appGetit.getParentChildren(parentId: appGetit.user!.id!);
      drivers = await appGetit.getDrivers();

      if (appGetit.user?.imageUrl != null) {
        imageUrl = appGetit.user!.imageUrl;
        emit(ImageUploadedState(imageUrl: imageUrl!));
      } else {
        emit(SuccessState());
      }
      emit(SuccessState());
    } on Exception catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  FutureOr<void> logOutMethod(
    LogOutEvent event,
    Emitter<ParentProfileState> emit,
  ) async {
    try {
      await authLayerGetit.signOut();
      emit(SuccessStatesignOut());
    } catch (e) {
      emit(ErrorsignOut(message: e.toString()));
    }
  }

  FutureOr<void> updateUserInfoMethd(
    UpdateUserInfoEvent event,
    Emitter<ParentProfileState> emit,
  ) async {
    try {
      UserModel currentUser = appGetit.user!;
      if (currentUser.email != controllerEmail.text.trim()) {
        updateUserEmail(
          userId: currentUser.id!,
          newEmail: controllerEmail.text,
        );
      }
      log("userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      UserModel user = await appGetit.updateUserInfo(
        user: UserModel(
          id: appGetit.user!.id,
          email: controllerEmail.text,
          name: controllerName.text,
          phone: controllerPhone.text,
          role: appGetit.user!.role,
          createdAt: appGetit.user!.createdAt,
          latitude: appGetit.user!.latitude,
          longitude: appGetit.user!.longitude,
        ),
      );
      appGetit.user = user;
      for (var child in childern!) {
        child = await appGetit.updateStudentInfo(
          child: StudentsModel(
            id: child.id,
            name: child.name,
            parentId: child.parentId,
            status: child.status,
            driverId: child.driverId,
            latitude: user.latitude,
            longitude: user.longitude,
          ),
        );
      }
      await appGetit.getUser(id: currentUser.id!);
      emit(SuccessState());
      log("User update failed: No user object in auth response.");
    } on AuthException catch (e) {
      log("AuthException during user info update: ${e.message}");
      emit(ErrorState(message: "Failed to update user info: ${e.message}"));
    } catch (e) {
      log("Unexpected error during user info update: $e");
      emit(ErrorState(message: "An unexpected error occurred: $e"));
    }
    controllerEmail.clear();
    controllerName.clear();
    controllerPhone.clear();
  }

  FutureOr<void> onUpdateMarkerLocation(
    UpdateMarkerLocationEvent event,
    Emitter<ParentProfileState> emit,
  ) {
    marker = HashSet<Marker>();
    cureentParentHouse = event.newLocation;
    marker.add(
      Marker(
        markerId: MarkerId('selectedLocation'),
        position: cureentParentHouse!,
        infoWindow: InfoWindow(title: "Selected Location"),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    emit(SuccessState());
  }

  FutureOr<void> _getImageFromGalleryMethod(
    GetImageFromGalleryEvent event,
    Emitter<ParentProfileState> emit,
  ) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage != null) {
        image = File(pickedImage.path);
        // نطلق حدث الرفع بعد اختيار الصورة بنجاح
        add(UploadImageEvent(image: image!));
      } else {
        emit(ErrorGetImage(message: "No image was selected."));
      }
    } on Exception catch (e) {
      emit(ErrorGetImage(message: e.toString()));
    }
  }

  FutureOr<void> _uploadImageMethod(
    UploadImageEvent event,
    Emitter<ParentProfileState> emit,
  ) async {
    final userId = GetIt.I.get<AuthServiceLayer>().currentUser?.id;
    if (userId == null) {
      log('Error: User ID not found. Please log in.');
      emit(ErrorGetImage(message: 'Error: User ID not found. Please log in.'));
      return;
    }

    emit(UploadingImageState());

    try {
      // توحيد مسار الحفظ لضمان عدم وجود تداخل
      final path = 'pics/$userId/profile.png';
      log('Starting image upload for user: $userId with path: $path');

      // رفع الصورة إلى Supabase Storage
      await appGetit.uploadImage(path: path, image: event.image);

      // الحصول على الرابط العام للصورة المرفوعة
      final publicUrl = await appGetit.getPublicImageUrl(path: path);
      log('Image uploaded successfully. Public URL: $publicUrl');

      // تحديث جدول 'users' بالرابط الجديد
      // تأكدنا من أن الـ userId ليس null قبل هذا الاستدعاء
      final updatedUser = await appGetit.updateUSerProfileImage(
        publicUrl: publicUrl,
        userId: userId,
      );

      imageUrl = updatedUser.imageUrl;
      log(
        "User profile updated in the database successfully with new URL: $imageUrl",
      );

      emit(ImageUploadedState(imageUrl: imageUrl!));
    } on Exception catch (e) {
      log('Error during image upload or database update: $e');
      emit(
        ErrorGetImage(
          message: 'Failed to upload image or update profile: ${e.toString()}',
        ),
      );
    }
  }
}

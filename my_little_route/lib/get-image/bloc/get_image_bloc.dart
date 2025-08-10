// // import 'dart:async';
// // import 'dart:developer';
// // import 'dart:io';

// // import 'package:bloc/bloc.dart';
// // import 'package:get_it/get_it.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:meta/meta.dart';
// // import 'package:my_little_route/data_layer/app_data_layer.dart';
// // import 'package:my_little_route/data_layer/auth_service_layer.dart';

// // part 'get_image_event.dart';
// // part 'get_image_state.dart';

// // class GetImageBloc extends Bloc<GetImageEvent, GetImageState> {
// //   // استخدام GetIt للوصول إلى طبقة البيانات
// //   final appGetit = GetIt.I.get<AppDataLayer>();
// //   // متغير لتخزين الصورة المحلية قبل الرفع
// //   File? image;
// //   // متغير لتخزين رابط الصورة بعد الرفع
// //   String? imageUrl;

// //   GetImageBloc() : super(GetImageInitial()) {
// //     // تم حذف السطر الزائد on<GetImageEvent>((event, emit) {});
// //     on<GetImageFromGalleryEvent>(getImageFromGalleryMethod);
// //     on<UploadImageEvent>(uploadImageMethod);
// //   }

// //   // دالة لالتقاط الصورة من المعرض
// //   FutureOr<void> getImageFromGalleryMethod(
// //     GetImageFromGalleryEvent event,
// //     Emitter<GetImageState> emit,
// //   ) async {
// //     try {
// //       final ImagePicker picker = ImagePicker();
// //       final XFile? pickedImage = await picker.pickImage(
// //         source: ImageSource.gallery,
// //       );

// //       if (pickedImage != null) {
// //         image = File(pickedImage.path);
// //         emit(SucssesGetImage());
// //       } else {
// //         emit(ErrorGetImage(message: "لم يتم اختيار أي صورة."));
// //       }
// //       add(UploadImageEvent());
// //     } on Exception catch (e) {
// //       emit(ErrorGetImage(message: e.toString()));
// //     }
// //   // }

// //   // دالة لرفع الصورة إلى Supabase Storage وتخزين الرابط
// //   FutureOr<void> uploadImageMethod(
// //     UploadImageEvent event,
// //     Emitter<GetImageState> emit,
// //   ) async {
// //     // التحقق من وجود الصورة قبل الرفع
// //     if (image == null) {
// //       emit(ErrorGetImage(message: "الرجاء اختيار صورة أولاً."));
// //       return;
// //     }
// //     if (appGetit.user == null) {
// //       log("appGetit.user == null");
// //      await appGetit.getUser(id: GetIt.I.get<AuthServiceLayer>().currentUser!.id);
// //     }
// //     emit(UploadingImageState());

// //     try {
// //       // مسار الصورة في الـ bucket، استخدم معرف المستخدم لضمان التفرد
// //       final path = 'pics/${appGetit.user?.id}/profile.png';

// //       // رفع الصورة إلى Supabase Storage
// //       await appGetit.uploadImage(path: path, image: image!);

// //       // الحصول على الرابط العام للصورة المرفوعة
// //       final publicUrl = await appGetit.getPublicImageUrl(path: path);

// //       // تحديث جدول 'users' بالرابط الجديد
// //       final result = await appGetit.updateUSerProfileImage(
// //         publicUrl: publicUrl,
// //         userId: appGetit.user!.id!,
// //       );

// //       imageUrl = publicUrl;
// //       emit(ImageUploadedState(imageUrl: publicUrl));
// //       print("end");
// //     } on Exception catch (e) {
// //       emit(ErrorGetImage(message: 'فشل في رفع الصورة: $e'));
// //     }
// //   }
// // }

// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';

// import 'package:bloc/bloc.dart';
// import 'package:get_it/get_it.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:meta/meta.dart';
// import 'package:my_little_route/data_layer/app_data_layer.dart';
// import 'package:my_little_route/data_layer/auth_service_layer.dart';
// import 'package:my_little_route/utilities/helper/upload_profile_image.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Add this import

// part 'get_image_event.dart';
// part 'get_image_state.dart';

// class GetImageBloc extends Bloc<GetImageEvent, GetImageState> {
//   final appGetit = GetIt.I.get<AppDataLayer>();
//   File? image;
//   String? imageUrl;

//   GetImageBloc() : super(GetImageInitial()) {
//     on<UploadImageEvent>(uploadImageMethod);
//   }

//   FutureOr<void> uploadImageMethod(
//     UploadImageEvent event,
//     Emitter<GetImageState> emit,
//   ) async {
//     emit(UploadingImageState());

//     try {
//       final userId = GetIt.I.get<AuthServiceLayer>().currentUser?.id;
//       if (userId == null) {
//         emit(
//           ErrorGetImage(message: 'Error: User ID not found. Please log in.'),
//         );
//         return;
//       }

//       // Use the helper function here
//       imageUrl = await getImageFromGalleryAndUploadToDBMethod(userId: userId);
//       await appGetit.updateUSerProfileImage(
//         publicUrl: imageUrl!,
//         userId: appGetit.user!.id!,
//       );
//       emit(ImageUploadedState(imageUrl: imageUrl!));
//       log("Image uploaded and user profile updated successfully!");
//     } on Exception catch (e) {
//       log('Error uploading image: $e');
//       emit(ErrorGetImage(message: 'Failed to upload image: ${e.toString()}'));
//     }
//   }
// }



 // get_image/bloc/get_image_bloc.dart
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/data_layer/auth_service_layer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'get_image_event.dart';
part 'get_image_state.dart';

class GetImageBloc extends Bloc<GetImageEvent, GetImageState> {
  final appGetit = GetIt.I.get<AppDataLayer>();
  File? image;
  String? imageUrl;

  GetImageBloc() : super(GetImageInitial()) {
    on<LoadInitialImageEvent>(_loadUserProfileImage);
    on<GetImageFromGalleryEvent>(_getImageFromGalleryMethod);
    on<UploadImageEvent>(_uploadImageMethod);
  }

  FutureOr<void> _loadUserProfileImage(
    LoadInitialImageEvent event,
    Emitter<GetImageState> emit,
  ) async {
    final userId = GetIt.I.get<AuthServiceLayer>().currentUser?.id;
    if (userId == null) {
      log('User ID not found, cannot load profile image.');
      emit(ErrorGetImage(message: "User not logged in."));
      return;
    }
    
    emit(UploadingImageState());
    
    try {
      final user = await appGetit.getUser(id: userId);
      if (user?.imageUrl != null) {
        imageUrl = user!.imageUrl;
        emit(ImageUploadedState(imageUrl: imageUrl!));
      } else {
        emit(GetImageInitial());
      }
    } on Exception catch (e) {
      log('Error loading initial profile image: $e');
      emit(ErrorGetImage(message: 'Failed to load profile image: ${e.toString()}'));
    }
  }

  FutureOr<void> _getImageFromGalleryMethod(
    GetImageFromGalleryEvent event,
    Emitter<GetImageState> emit,
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
    Emitter<GetImageState> emit,
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
      log("User profile updated in the database successfully with new URL: $imageUrl");
      
      emit(ImageUploadedState(imageUrl: imageUrl!));
    } on Exception catch (e) {
      log('Error during image upload or database update: $e');
      emit(ErrorGetImage(message: 'Failed to upload image or update profile: ${e.toString()}'));
    }
  }
}

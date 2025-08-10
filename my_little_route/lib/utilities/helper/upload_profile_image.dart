// import 'dart:io';

// import 'package:get_it/get_it.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:my_little_route/data_layer/app_data_layer.dart';

// Future<String> getImageFromGalleryAndUploadToDBMethod({
//   required File? image,
//   required String userId,
// }) async {
//   try {
//     final appGetit = GetIt.I.get<AppDataLayer>();

//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedImage = await picker.pickImage(
//       source: ImageSource.gallery,
//     );
//     if (image == null) {
//       throw Exception("الرجاء اختيار صورة أولاً.");
//     }

//     // مسار الصورة في الـ bucket، استخدم معرف المستخدم لضمان التفرد
//     final path = 'pics/$userId/profile.png';
//     // رفع الصورة إلى Supabase Storage
//     await appGetit.uploadImage(path: path, image: image);

//     // الحصول على الرابط العام للصورة المرفوعة
//     final publicUrl = await appGetit.getPublicImageUrl(path: path);

//     // تحديث جدول 'users' بالرابط الجديد
//     await appGetit.updateUSerProfileImage(
//       publicUrl: publicUrl,
//       userId: appGetit.user!.id!,
//     );

//     return publicUrl;
//   } on Exception catch (e) {
//     throw Exception(e.toString());
//   }
// }


import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';

/// A helper function to get an image from the gallery, upload it to Supabase,
/// and then update the user's profile image URL in the database.
///
/// Parameters:
/// - [userId]: The current user's ID, used to create a unique path in Supabase Storage.
///
/// Returns:
/// - [Future<String>]: The public URL of the image after a successful upload.
///
/// Errors:
/// - [Exception]: An exception is thrown if any step fails (e.g., no image selected,
///   upload failure, or database update failure).
Future<String> getImageFromGalleryAndUploadToDBMethod({
 required String userId,
}) async {
 try {
  final appGetit = GetIt.I.get<AppDataLayer>();

  final ImagePicker picker = ImagePicker();
  final XFile? pickedImage = await picker.pickImage(
 source: ImageSource.gallery,
  );

 // Check if the user has selected an image
  if (pickedImage == null) {
 throw Exception("No image was selected.");
 }

    // Convert XFile to File
    final File imageFile = File(pickedImage.path);

 // The image path in the bucket, using the user ID for uniqueness
  final path = 'pics/$userId/profile.png';
 
 // Upload the image to Supabase Storage
 await appGetit.uploadImage(path: path, image: imageFile);

 // Get the public URL of the uploaded image
  final publicUrl = await appGetit.getPublicImageUrl(path: path);

 // Update the 'users' table with the new URL using the provided userId
  await appGetit.updateUSerProfileImage(
  publicUrl: publicUrl,
  userId: userId,
  );

  return publicUrl;
   } on Exception catch (e) {
  // Rethrow the exception with a more detailed message if necessary
 throw Exception('Failed to upload image: ${e.toString()}');
 }
}

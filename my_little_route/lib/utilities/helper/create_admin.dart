import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_little_route/data_layer/auth_service_layer.dart';

// Future<void> createUser(
//   String email,
//   String password,
//   String accessToken,
// ) async {
//   log("sssssssssssssssssssssssss");
//   final url =
//       'https://acxzbmvgkowyhdvcnwky.supabase.co/functions/v1/create-admin';

//   final response = await http.post(
//     Uri.parse(url),
//     headers: {
//       'Content-Type': 'application/json',

//       'Authorization': 'Bearer $accessToken',
//     },
//     body: jsonEncode({'email': email, 'password': password}),
//   );
//   log(response.body.toString());

//   if (response.statusCode == 200) {
//       log("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
     
//     // تم إنشاء المستخدم بنجاح
//     log('User created: ${response.body}');
//   } else {
//     // حدث خطأ
//       log("weeeeeeeeeeeeeeeeeeeeee");

//     log('Error: ${response.body}');
//   }
// }


Future<String?> createUser(
  String email,
  String password,
  String accessToken,
) async {
  // 'https://acxzbmvgkowyhdvcnwky.supabase.co/functions/v1/create-admin'
  final url =
      "https://acxzbmvgkowyhdvcnwky.supabase.co/functions/v1/create-user-no-verification";

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final id = data['id'] as String?;
    return id; // يرجع الـ id فقط
  } else {
    // يمكنك هنا معالجة الخطأ أو إرجاع null
    return null;
  }
}
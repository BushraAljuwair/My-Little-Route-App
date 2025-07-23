import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void updateUserEmail({required String userId, required String newEmail}) async {
  final url = 'https://acxzbmvgkowyhdvcnwky.supabase.co/functions/v1/update-user-email';
  final serviceRoleKey = dotenv.env['service_rolesecret'];

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serviceRoleKey',
    },
    body: jsonEncode({
      'user_id': userId,
      'email': newEmail,
    }),
  );

  if (response.statusCode == 200) {
    log('تم تحديث الإيميل بنجاح: ${response.body}');
  } else {
    log('حدث خطأ: ${response.body}');
  }
}
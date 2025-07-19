import 'dart:developer';

import 'package:my_little_route/models/user/user_model.dart';
import 'package:my_little_route/repository/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthLayer {

  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      log("AuthLayer start register user $email $password");
      final resopnse = await SupabaseConnect.signUp(
        email: email,
        password: password,
      );
      log("AuthLayer end succsfly");
      return resopnse;
    } on Exception catch (_) {
      log("AuthLayer throw Exception in AuthLayer ");
      rethrow;
    }
  }

  Future<void> addUserInUserTable({required UserModel user}) async {
    try {
      log("AuthLayer addUserInUserTable start ");

      await SupabaseConnect.addUserInUserTable(user: user);
      log("AuthLayer end succsfly addUserInUserTable");
    } on Exception catch (_) {
      log("AuthLayerthrow rethrow ");
      rethrow;
    }
  }

  
      Future<void> logIn({
    required String email,
    required String password,
  }) async {
    try {
      log("start logIn user $email $password");
      final AuthResponse? response = await SupabaseConnect.logIn(email: email,password: password);
      log(response.toString());
      log("end logIn succsfly");
     } on Exception catch (e) {
      log("throw Exception in subabase  logIn");
      throw FormatException("error in register $e");
    }
  }
}

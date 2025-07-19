import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_little_route/models/user/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConnect {
  static SupabaseClient? supabase;
  static Future<void> init() async {
    try {
      await Supabase.initialize(
        anonKey: dotenv.env['anonKey'].toString(),
        url: dotenv.env['url'].toString(),
        authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
      );

      supabase = Supabase.instance.client;
    } catch (e) {
      throw FormatException('error in db initialization: $e');
    }
  }

  static Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      log("start register user $email $password");
      final AuthResponse response = await supabase!.auth.signUp(
        email: email,
        password: password,
      );
      log("end succsfly");
      return response.user!.id;
    } on Exception catch (e) {
      log("throw Exception in subabase ");
      throw FormatException("error in register $e");
    }
  }

  static Future<AuthResponse?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      log("start logIn user $email $password");
      final AuthResponse response = await supabase!.auth.signInWithPassword(
        email: email,
        password: password,
      );
      log("end logIn succsfly");
      return response;
    } on Exception catch (e) {
      log("throw Exception in subabase  logIn");
      throw FormatException("error in register $e");
    }
  }

  static Future<void> addUserInUserTable({required UserModel user}) async {
    try {
      log("addUserInUserTable start register user");

      await supabase!.from('users').insert(user.toMap());
      log("end succsfly addUserInUserTable");
    } on Exception catch (e) {
      log("throw Exception in subabase ");
      throw FormatException("error in register addUserInUserTable $e");
    }
  }

  static Future<UserModel?> getUser({required String id}) async {
    try {
      log("start getting user ");
      final userMap = await supabase!
          .from('users')
          .select()
          .eq('id', id)
          .maybeSingle();
      if (userMap == null) {
        log("user not found with ID: $id");
        return null;
      }
      final user = UserModelMapper.fromMap(userMap);
      log("end getting user ");
      log(user.toString());
      return user;
    } catch (e) {
      log("erorr  in get user $e");
      throw Exception("error in get user $e");
    }
  }
}

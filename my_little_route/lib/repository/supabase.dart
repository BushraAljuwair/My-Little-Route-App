import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_little_route/features/kindergarten/add_admin/bloc/add_admin_bloc.dart';
import 'package:my_little_route/models/buses/buses_model.dart';
import 'package:my_little_route/models/student/students_models.dart';
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

  static Future<List<BusesModel>> getBuses() async {
    try {
      log("start getBuses"); // Changed log message for clarity

      // Perform the select query. Supabase usually returns a List<Map<String, dynamic>>
      final response = await supabase!.from('buses').select();

      // Check if the response is not null and is a List
      if (response != null && response.isNotEmpty) {
        // Map the list of dynamic maps (from Supabase) to a List of BusesModel objects.
        // .map returns an Iterable, so .toList() is essential to convert it to a List.
        final List<BusesModel> buses = response
            .map((busMap) => BusesModelMapper.fromMap(busMap))
            .toList();

        for (var element in buses) {
          log(element.toString());
        }
        log("end getting buses. Found ${buses.length} buses.");
        return buses; // Return the list of buses
      } else {
        log("Supabase response for buses was null or not a list.");
        return []; // Return an empty list if no data or unexpected response
      }
    } catch (e) {
      log("Error in getBuses: $e"); // Changed log message
      // Re-throwing the exception is good for error propagation
      throw Exception("Failed to get buses: $e");
    }
  }

  static Future<List<UserModel>> getDrivers() async {
    List<UserModel> drivers;
    try {
      final resopnse = await supabase!
          .from('users')
          .select()
          .eq("role", 'driver');
      if (resopnse != null && resopnse.isNotEmpty) {
        drivers = resopnse.map((driver) {
          return UserModelMapper.fromMap(driver);
        }).toList();
        return drivers;
      }
    } catch (e) {
      throw Exception("error in get driver $e");
    }
    return [];
  }

  static Future<List<StudentsModel>> getStudents() async {
    List<StudentsModel> students;
    try {
      log("start getStudents");
      final response = await supabase!.from('students').select();
      log("response getStudents end ");

      if (response.isNotEmpty && response != null) {
        log("response not empty  ");

        students = response
            .map((student) => StudentsModelMapper.fromMap(student))
            .toList();

        return students;
      }
    } catch (e) {
      log("error in gettting students $e");

      throw Exception("error in gettting students $e");
    }
    return [];
  }

  static Future<void> signOut() async {
    try {
      log("start log out ");
      await supabase!.auth.signOut();
      log("end log out ");
    } catch (e) {
      log("error  log out $e");
      throw Exception("error in log out $e");
    }
  }

  static Future<void> updateUserInfo({required UserModel user}) async {
    try {
      log("updateUserInfo start  user");

      await supabase!.from('users').update(user.toMap()).eq('id', user.id!);
      log("end succsfly updateUserInfo");
    } on Exception catch (e) {
      log("throw Exception in subabase ");
      throw FormatException("error in update  $e");
    }
  }
 
}

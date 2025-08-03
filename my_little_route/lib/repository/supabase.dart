import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_little_route/features/kindergarten/add_admin/bloc/add_admin_bloc.dart';
import 'package:my_little_route/models/buses/buses_model.dart';
import 'package:my_little_route/models/student/students_models.dart';
import 'package:my_little_route/models/trip/trip_model.dart';
import 'package:my_little_route/models/trip_stop/trip_stop_model.dart';
import 'package:my_little_route/models/trip_students/trip_students_model.dart';
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

  static Future<BusesModel> getBusForDriver({required String id}) async {
    try {
      log("getBusForDriver start   ");

      final response = await supabase!
          .from('buses')
          .select()
          .eq('driver_id', id)
          .single();
      BusesModel bus = BusesModelMapper.fromMap(response);
      log("end succsfly getBusForDriver");
      return bus;
    } on Exception catch (e) {
      log("throw Exception in subabase ");
      throw FormatException("error in get Bus  $e");
    }
  }

  static Future<UserModel> updateHuseLocation({
    required String id,
    required LatLng newLocation,
  }) async {
    try {
      log("  start   ");

      final response = await supabase!
          .from('users')
          .update({
            'latitude': newLocation.latitude,
            'longitude': newLocation.longitude,
          })
          .eq('id', id)
          .select()
          .single();

      UserModel user = UserModelMapper.fromMap(response);
      log("end succsfly  ");
      return user;
    } on Exception catch (e) {
      log("throw Exception in subabase ");
      throw FormatException("error in update location $e");
    }
  }

  static Future<List<StudentsModel>> getStudentForDriver({
    required String driverID,
  }) async {
    try {
      log("getStudentForDriver start   ");

      final response = await supabase!
          .from('students')
          .select()
          .eq('driver_id', driverID);
      List<StudentsModel> students = response
          .map((student) => StudentsModelMapper.fromMap(student))
          .toList();
      for (var element in students) {
        log(element.toString());
      }
      log("getStudentForDriver end succsfly getBusForDriver");
      return students;
    } on Exception catch (e) {
      log("throw Exception in subabase ");
      throw FormatException("error in get students  $e");
    }
  }

  static Future<TripModel> createTrip({required TripModel newTrip}) async {
    try {
      log("insertNewTrip start   ");
      final mapTrip = newTrip.toMap();
      mapTrip.remove('id');
      final response = await supabase!
          .from('trips')
          .insert(mapTrip)
          .select()
          .single();
      log("response ${response.toString()}");
      TripModel trip = TripModelMapper.fromMap(response);
      log("end succsfly insertNewTrip");

      return trip;
    } on Exception catch (e) {
      log("throw Exception in subabase ");
      throw FormatException("error in insertNewTrip  $e");
    }
  }

  static Future<List<TripStudentsModel>> sendStudentsTrip({
    required List<Map<String, dynamic>> tripStudentsList,
  }) async {
    try {
      log("  start   ");

      final response = await supabase!
          .from('trip_students')
          .insert(tripStudentsList)
          .select();
      log("!11111111111111111111111111111");
      log("!11111111111111111111111111111");
      log("!11111111111111111111111111111");
      for (var element in response) {
        log(element.toString());
      }
      log("!11111111111111111111111111111");
      log("!11111111111111111111111111111");
      log("!11111111111111111111111111111");
      final studentsTrips = response.map((trips) {
        return TripStudentsModelMapper.fromMap(trips);
      }).toList();

      log("end succsfly  ");

      return studentsTrips;
    } on Exception catch (e) {
      log("throw Exception in subabase ");
      throw FormatException("error in    $e");
    }
  }

  static Future<void> sendTripStops({
    required List<Map<String, dynamic>> tripStopsList,
  }) async {
    try {
      log("aaaaaaaaaaaaaaaaaaaa");
      await supabase!.from('trip_stops').insert(tripStopsList).select();

      log("n nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");
    } on Exception catch (e) {
      throw FormatException("خطأ في إدخال trip_stops: $e");
    }
  }

  static Future<TripStudentsModel> updateStudentPickupStatus({
    required TripStudentsModel studentTrip,
  }) async {
    try {
      log("updateStudentPickupStatus start ");
      final result = await supabase!
          .from('trip_students')
          .update({
            'pickup_status': studentTrip.pickupStatus,
            'pickup_time': studentTrip.pickupTime?.toIso8601String(),
          })
          .eq('student_id', studentTrip.studentId)
          .eq('trip_id', studentTrip.tripId)
          .select()
          .single();
      log("updateStudentPickupStatus end");

      return TripStudentsModelMapper.fromMap(result);
    } on Exception catch (e) {
      throw FormatException("error in update status $e");
    }
  }

  static Future<TripStudentsModel> updateStudentDropOffStatus({
    required TripStudentsModel studentTrip,
  }) async {
    try {
      log("updateStudentPickupStatus start ");
      final result = await supabase!
          .from('trip_students')
          .update({
            'dropoff_status': studentTrip.pickupStatus,
            'dropoff_time': studentTrip.pickupTime?.toIso8601String(),
          })
          .eq('student_id', studentTrip.studentId)
          .eq('trip_id', studentTrip.tripId)
          .select()
          .single();
      log("updateStudentPickupStatus end");

      return TripStudentsModelMapper.fromMap(result);
    } on Exception catch (e) {
      throw FormatException("error in update status $e");
    }
  }

  static Future<TripModel> getTrip({required String tripId}) async {
    try {
      log("getTripgetTripgetTripgetTrip start ");
      final result = await supabase!
          .from('trips')
          .select()
          .eq('id', tripId)
          .single();
      log(" end");

      return TripModelMapper.fromMap(result);
    } on Exception catch (e) {
      throw FormatException("error in get trip  $e");
    }
  }

  static Future<List<TripStopModel>> getTripStops({
    required String tripId,
  }) async {
    try {
      log("getTripgetTripgetTripgetTrip start ");
      final result = await supabase!
          .from('trip_stops')
          .select()
          .eq('trip_id', tripId);

      final tripStops = result.map((stop) {
        return TripStopModelMapper.fromMap(stop);
      }).toList();
      for (var element in tripStops) {
        log(element.toString());
      }
      log(" end");
      return tripStops;
    } on Exception catch (e) {
      throw FormatException("error in get trip  $e");
    }
  }

  static Future<List<TripStudentsModel>> getStudentsTrip({
    required String tripId,
  }) async {
    try {
      log("getStudentsTrip  start ");
      final result = await supabase!
          .from('trip_students')
          .select()
          .eq('trip_id', tripId);

      final studentsTrip = result.map((stop) {
        return TripStudentsModelMapper.fromMap(stop);
      }).toList();
      for (var element in studentsTrip) {
        log(element.toString());
      }
      log("getStudentsTrip  end");
      return studentsTrip;
    } on Exception catch (e) {
      throw FormatException("error in get studentsTrip  $e");
    }
  }
}

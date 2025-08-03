import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_little_route/models/buses/buses_model.dart';
import 'package:my_little_route/models/student/students_models.dart';
import 'package:my_little_route/models/trip/trip_model.dart';
import 'package:my_little_route/models/trip_stop/trip_stop_model.dart';
import 'package:my_little_route/models/trip_students/trip_students_model.dart';
import 'package:my_little_route/models/user/user_model.dart';
import 'package:my_little_route/repository/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppDataLayer {
  UserModel? user;

  Future<UserModel?> getUser({required String id}) async {
    try {
      log("start get user ");
      user = await SupabaseConnect.getUser(id: id);
      log("end get user ");
      log(user.toString());
    } catch (e) {
      log("rethrow the error");
      rethrow;
    }
    return user;
  }

  Future<List<BusesModel?>> getBuses() async {
    try {
      log("getBuses()in app layer start ");
      List<BusesModel> buses = await SupabaseConnect.getBuses();
      log("getBuses()in app layer end");
      return buses;
    } catch (_) {
      log("rethrow app layer");
      rethrow;
    }
  }

  Future<List<UserModel>> getDrivers() async {
    List<UserModel> drivers;
    try {
      log("start get driver ");
      drivers = await SupabaseConnect.getDrivers();
      log("end get driver ");
      log(drivers.toString());
    } catch (e) {
      log("rethrow the error");
      rethrow;
    }
    return drivers;
  }

  Future<List<StudentsModel>> getStudens() async {
    List<StudentsModel> drivers;
    try {
      log("AppDataLayer start  getStudens ");
      drivers = await SupabaseConnect.getStudents();
      log("AppDataLayer end get students ");
      log(drivers.toString());
    } catch (e) {
      log("rethrow the error");
      rethrow;
    }
    return drivers;
  }

  Future<void> updateUserInfo({required UserModel user}) async {
    try {
      log("AppDataLayer  updateUserInfo start  user");

      await SupabaseConnect.updateUserInfo(user: user);
      log("AppDataLayer end succsfly updateUserInfo");
    } on Exception catch (e) {
      log("AppDataLayer  throw Exception in subabase ");
      throw FormatException("error in update  $e");
    }
  }

  Future<BusesModel> getBusForDriver({required String id}) async {
    log("1");
    try {
      BusesModel bus = await SupabaseConnect.getBusForDriver(id: id);
      log("2");
      return bus;
    } catch (_) {
      log("3");
      rethrow;
    }
  }

  Future<void> updateHuseLocation({
    required String id,
    required LatLng newLocation,
  }) async {
    log("1");
    try {
      user = await SupabaseConnect.updateHuseLocation(
        id: id,
        newLocation: newLocation,
      );
      log("2");
    } catch (_) {
      log("3");
      rethrow;
    }
  }

  Future<List<StudentsModel>> getStudentForDriver({required String id}) async {
    log("1");
    List<StudentsModel> students;
    try {
      students = await SupabaseConnect.getStudentForDriver(driverID: id);
      log("2");
    } catch (_) {
      log("3");
      rethrow;
    }
    return students;
  }

  Future<TripModel> createTrip({required TripModel newTrip}) async {
    try {
      log("insertNewTrip start   ");
      log(newTrip.toString());
      TripModel trip = await SupabaseConnect.createTrip(newTrip: newTrip);

      log("response end ");
      log("end succsfly insertNewTrip");

      return trip;
    } on Exception catch (_) {
      log("throw Exception in subabase ");
      rethrow;
    }
  }

  Future<List<TripStudentsModel>> sendStudentsTrip({
    required List<Map<String, dynamic>> tripStudentsList,
  }) async {
    try {
      log("start   ");
      final result = await SupabaseConnect.sendStudentsTrip(
        tripStudentsList: tripStudentsList,
      );

      log("end  ");
      return result;
    } on Exception catch (_) {
      log("rethrow");
      rethrow;
    }
  }

  Future<void> sendTripStops({
    required List<Map<String, dynamic>> tripStopsList,
  }) async {
    try {
      log("1");
      await SupabaseConnect.sendTripStops(tripStopsList: tripStopsList);
      log("2");
    } catch (_) {
      log("3");
      rethrow;
    }
  }

  Future<TripStudentsModel> updateStudentPickupStatus({
    required TripStudentsModel studentTrip,
  }) async {
    try {
      log("updateStudentPickupStatus start app data layer ");
      final result = await SupabaseConnect.updateStudentPickupStatus(
        studentTrip: studentTrip,
      );
      log("updateStudentPickupStatus end app data layer ");
      return result;
    } on Exception catch (_) {
      log("rethrow end app data layer ");

      rethrow;
    }
  }

  Future<TripModel> getTrip({required String tripId}) async {
    try {
      log("getTrip start ");
      final result = await SupabaseConnect.getTrip(tripId: tripId);
      log("getTrip end");

      return result;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<List<TripStopModel>> getTripStops({required String tripId}) async {
    try {
      log("getTripStops                                              start ");
      final result = await SupabaseConnect.getTripStops(tripId: tripId);
      log(" getTripStops                       end");
      return result;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<List<TripStudentsModel>> getStudentsTrip({
    required String tripId,
  }) async {
    try {
      log("getStudentsTrip  start ");
      final result = await SupabaseConnect.getStudentsTrip(tripId: tripId);

      return result;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<TripStudentsModel> updateStudentDropOffStatus({
    required TripStudentsModel studentTrip,
  }) async {
    try {
      log("updateStudentDropOffStatus start app data layer");
      final result = await SupabaseConnect.updateStudentDropOffStatus(
        studentTrip: studentTrip,
      );
      log("updateStudentDropOffStatus end  app data layer");
      return result;
    } on Exception catch (e) {
      throw FormatException(" $e");
    }
  }
}

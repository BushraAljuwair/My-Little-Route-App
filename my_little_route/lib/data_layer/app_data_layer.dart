import 'dart:developer';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_little_route/models/bus_locations/bus_locations_model.dart';
import 'package:my_little_route/models/buses/buses_model.dart';
import 'package:my_little_route/models/notifications/notifications_model.dart';
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

  Future<UserModel> updateUserInfo({required UserModel user}) async {
    try {
      log("AppDataLayer  updateUserInfo start  user");

      return await SupabaseConnect.updateUserInfo(user: user);
     } on Exception catch (e) {
      log("AppDataLayer  throw Exception in subabase $e");
      rethrow;
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
    bool? isChild,
  }) async {
    log("1");
    try {
      user = await SupabaseConnect.updateHuseLocation(
        id: id,
        newLocation: newLocation,
        isChild: isChild,
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

  Future<List<TripStopModel>> sendTripStops({
    required List<Map<String, dynamic>> tripStopsList,
  }) async {
    try {
      log("1");
      return await SupabaseConnect.sendTripStops(tripStopsList: tripStopsList);
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

  Future<BusLocationsModel> updateOrInsertDriverLocation({
    String? id,
    required String busId,
    required double latitude,
    required double longitude,
  }) async {
    log('start updateDriverLocation');
    try {
      final result = await SupabaseConnect.updateOrInsertDriverLocation(
        id: id,
        busId: busId,
        latitude: latitude,
        longitude: longitude,
      );
      return result;
    } catch (e) {
      log(e.toString());

      rethrow;
    }
  }

  Future<void> updateLocationInSupabase(Position position, String busId) async {
    try {
      await SupabaseConnect.updateLocationInSupabase(position, busId);

      log(
        "📍 Location updated to Supabase: (${position.latitude}, ${position.longitude})",
      );
    } catch (e) {
      log("❌ Failed to update location: $e");
    }
  }

  Future<void> changeDropOffStatus({
    required List<TripStudentsModel> studentsTrip,
  }) async {
    log("🏁 endPickupTrip: app data layer start ");

    try {
      await SupabaseConnect.changeDropOffStatus(studentsTrip: studentsTrip);

      log("🏁 endPickupTrip: app data layer end ");
    } catch (e) {
      log("🏁 endPickupTrip: app data layer start $e");

      rethrow;
    }
  }

  Future<void> changeTripTypeCompleted({required String id}) async {
    log("🏁 endReturnTrip: الدالة بدأت لإنهاء الرحلة ID: $id");

    try {
      await SupabaseConnect.changeTripTypeCompleted(id: id);
    } catch (e) {
      log("❌ endReturnTrip: فشل في تحديث بيانات الرحلة أو الطلاب: $e");
      throw Exception(e.toString());
    }
  }

  Future<void> notification({
    required List<NotificationsModel> notifcation,
  }) async {
    log("app data layer notification subabase start ");
    try {
      await SupabaseConnect.notification(notifcation: notifcation);

      log("app data layer notification subabase end ");
    } catch (e) {
      log("notification subabase rethrow ");
      rethrow;
    }
  }

  Future<void> notificationParent({
    required NotificationsModel notifcation,
  }) async {
    log("notificationParent   start ");
    try {
      await SupabaseConnect.notificationParent(notifcation: notifcation);

      log("notificationParent   end ");
    } catch (e) {
      log("notificationParent   throw ");
      throw Exception(e.toString());
    }
  }

  Future<void> uploadImage({required String path, required File image}) async {
    log(" app data layer uploadImage subabase start ");
    try {
      await SupabaseConnect.uploadImage(image: image, path: path);
      log(" app data layer  uploadImage subabase end ");
    } catch (e) {
      log(" app data layer  uploadImage subabase throw ");
      throw Exception(e.toString());
    }
  }

  Future<String> getPublicImageUrl({required String path}) async {
    log("getPublicImageUrl subabase start ");
    try {
      final result = await SupabaseConnect.getPublicImageUrl(path: path);
      log("getPublicImageUrl subabase end ");
      return result;
    } catch (e) {
      log("getPublicImageUrl subabase throw ");
      throw Exception(e.toString());
    }
  }

  Future<UserModel> updateUSerProfileImage({
    required String publicUrl,
    required String userId,
  }) async {
    log("app data layer  updateUSerProfileImage start ");
    try {
      return await SupabaseConnect.updateUSerProfileImage(
        publicUrl: publicUrl,
        userId: userId,
      );
    } catch (e) {
      log("app data layer  updateUSerProfileImage rethrows ");
      rethrow;
    }
  }

  Future<List<StudentsModel>> getParentChildren({
    required String parentId,
  }) async {
    try {
      log("app data layer start getParentChildren");
      return await SupabaseConnect.getParentChildren(parentId: parentId);
    } catch (e) {
      log("app data layer error in gettting getParentChildren $e");

      rethrow;
    }
  }

  Future<StudentsModel> updateStudentInfo({
    required StudentsModel child,
  }) async {
    try {
      log("app data layer  start   ");

      final response = await SupabaseConnect.updateStudentInfo(child: child);

      log("app data layer end succsfly  ");
      return response;
    } catch (e) {
      log("throw Exception in subabase ");
      rethrow;
    }
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  static Future<UserModel> updateUserInfo({required UserModel user}) async {
    try {
      log("updateUserInfo start  user");

      final response = await supabase!
          .from('users')
          .update(user.toMap())
          .eq('id', user.id!)
          .select()
          .single();
      log("end succsfly updateUserInfo");
      return UserModelMapper.fromMap(response);
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

  static Future<UserModel?> updateHuseLocation({
    required String id,
    required LatLng newLocation,
    bool? isChild = false,
  }) async {
    try {
      log("  start   ");

      if (isChild != null && isChild) {
        final response = await supabase!
            .from('students')
            .update({
              'latitude': newLocation.latitude,
              'longitude': newLocation.longitude,
            })
            .eq('id', id);
        log("chid new location response");
      } else {
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
      }
    } on Exception catch (e) {
      log("throw Exception in subabase ");
      throw FormatException("error in update location $e");
    }
  }

  static Future<StudentsModel> updateStudentInfo({
    required StudentsModel child,
  }) async {
    try {
      log("  start   ");
      final childMap = child.toMap();
      childMap.remove("id");
      final response = await supabase!
          .from('students')
          .update(childMap)
          .eq('id', child.id!)
          .select()
          .single();
      log("chid new location response");

      log("end succsfly  ");
      return StudentsModelMapper.fromMap(response);
    } catch (e) {
      log("throw Exception in subabase ");
      throw FormatException("$e");
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

  static Future<List<TripStopModel>> sendTripStops({
    required List<Map<String, dynamic>> tripStopsList,
  }) async {
    try {
      log("aaaaaaaaaaaaaaaaaaaa");
      final result = await supabase!
          .from('trip_stops')
          .insert(tripStopsList)
          .select();

      List<TripStopModel> stops = result
          .map((stop) => TripStopModelMapper.fromMap(stop))
          .toList();
      log("n nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");
      return stops;
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
      log("updateStudentDropOffStatus start ");
      final result = await supabase!
          .from('trip_students')
          .update({
            // التصحيح: استخدام حالة الإنزال وزمن الإنزال
            'dropoff_status': studentTrip.dropoffStatus,
            'dropoff_time': studentTrip.dropoffTime?.toIso8601String(),
          })
          .eq('student_id', studentTrip.studentId)
          .eq('trip_id', studentTrip.tripId)
          .select()
          .single();
      log("updateStudentDropOffStatus end");
      log(result.toString());

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

      log("getStudentsTrip  end");
      return studentsTrip;
    } on Exception catch (e) {
      throw FormatException("error in get studentsTrip  $e");
    }
  }

  static Future<BusLocationsModel> updateOrInsertDriverLocation({
    String? id,
    required String busId,
    required double latitude,
    required double longitude,
  }) async {
    log('start updateDriverLocation');

    try {
      if (id == null) {
        var response = await supabase!
            .from('bus_locations')
            .insert({
              "bus_id": busId,
              "latitude": latitude,
              "longitude": longitude,
              "timestamp": DateTime.now().toIso8601String(),
            })
            .select()
            .single();
        log('end updateDriverLocation');
        return BusLocationsModelMapper.fromMap(response);
      } else {
        var response = await supabase!
            .from('bus_locations')
            .update({
              "latitude": latitude,
              "longitude": longitude,
              "timestamp": DateTime.now().toIso8601String(),
            })
            .eq("id", id)
            .select()
            .single();

        log('end updateDriverLocation');
        return BusLocationsModelMapper.fromMap(response);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> updateLocationInSupabase(
    Position position,
    String busId,
  ) async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.from('bus_locations').insert({
        'bus_id': busId,
        'latitude': position.latitude,
        'longitude': position.longitude,
      });

      log(
        "📍 Location updated to Supabase: (${position.latitude}, ${position.longitude})",
      );
    } catch (e) {
      log("❌ Failed to update location: $e");
    }
  }

  Stream<List<BusLocationsModel>> listenToBusLocation(String busId) {
    final supabase = Supabase.instance.client;

    return supabase
        .from('bus_locations')
        .stream(primaryKey: ['bus_id'])
        .eq('bus_id', busId)
        .map(
          (maps) =>
              maps.map((map) => BusLocationsModelMapper.fromMap(map)).toList(),
        );
  }

  static Future<void> changeDropOffStatus({
    required List<TripStudentsModel> studentsTrip,
  }) async {
    try {
      for (var element in studentsTrip) {
        log(
          "🔍 endPickupTrip: فحص الطالب ID: ${element.studentId}، حالة الالتقاط: ${element.pickupStatus}",
        );
        if (element.pickupStatus) {
          await supabase!
              .from('trip_students')
              .update({
                'dropoff_status': true,
                "dropoff_time": DateTime.now().toIso8601String(),
              })
              .eq("trip_id", element.tripId)
              .eq("student_id", element.studentId);
        }
      }
      log("🎉 endPickupTrip: جميع الطلاب تم فحصهم بنجاح.");
    } catch (e) {
      log("❌ endPickupTrip: فشل في تحديث بيانات الرحلة أو الطلاب: $e");
      throw Exception(e.toString());
    }
  }

  static Future<void> changeTripTypeCompleted({required String id}) async {
    log("🏁 endReturnTrip: الدالة بدأت لإنهاء الرحلة ID: $id");

    try {
      await supabase!
          .from('trips')
          .update({'status': "completed"})
          .eq("id", id);
    } catch (e) {
      log("❌ endReturnTrip: فشل في تحديث بيانات الرحلة أو الطلاب: $e");
      throw Exception(e.toString());
    }
  }

  static Future<void> notification({
    required List<NotificationsModel> notifcation,
  }) async {
    log("notification subabase start");
    try {
      if (notifcation.isEmpty) {
        log("notifications list is empty. No data to insert.");
        return;
      }

      final List<Map<String, dynamic>> notificationsToInsert = notifcation.map((
        element,
      ) {
        final notificationMap = element.toMap();
        notificationMap.remove('id');
        return notificationMap;
      }).toList();

      // استخدام Future.microtask لضمان عدم حظر الخيط الرئيسي

      final result = await supabase!
          .from("notifications")
          .insert(notificationsToInsert)
          .select();
      log("notification subabase end. Inserted ${result.length} records.");
    } catch (e) {
      log("notification subabase throw, an error occurred.");
      log("Error details: ${e.toString()}");
      // ✅ طرح استثناء ليتم التقاطه في الدالة التي قامت بالمناداة
      throw Exception("notification subabase throw: ${e.toString()}");
    }
  }

  static Future<void> uploadImage({
    required String path,
    required File image,
  }) async {
    log("uploadImage subabase start ");
    try {
      await supabase!.storage
          .from('user-profile-image')
          .upload(path, image, fileOptions: const FileOptions(upsert: true));

      log("uploadImage subabase end ");
    } catch (e) {
      log("uploadImage subabase throw ");
      throw Exception(e.toString());
    }
  }

  static Future<String> getPublicImageUrl({required String path}) async {
    log("getPublicImageUrl subabase start ");
    try {
      final result = await supabase!.storage
          .from('user-profile-image')
          .getPublicUrl(path);

      log("getPublicImageUrl subabase end ");
      return result;
    } catch (e) {
      log("getPublicImageUrl subabase throw ");
      throw Exception(e.toString());
    }
  }

  static Future<UserModel> updateUSerProfileImage({
    required String publicUrl,
    required String userId,
  }) async {
    log("getPublicImageUrl subabase start ");
    try {
      final user = await supabase!
          .from('users')
          .update({'image_url': publicUrl})
          .eq('id', userId)
          .select()
          .single();

      log("getPublicImageUrl subabase end ");
      return UserModelMapper.fromMap(user);
    } catch (e) {
      log("getPublicImageUrl subabase throw ");
      throw Exception(e.toString());
    }
  }

  static Future<void> notificationParent({
    required NotificationsModel notifcation,
  }) async {
    log("notificationParent subabase start ");
    try {
      // 1. تحويل الـ NotificationsModel إلى Map<String, dynamic>.
      final mapNotifcation = notifcation.toMap();

      // 2. إزالة حقل 'id' من الـ Map،
      // لكي يتم إنشاء ID جديد تلقائيًا بواسطة Supabase.
      mapNotifcation.remove('id');

      // 3. استخدام الـ Map المعدّل في دالة insert.
      // هذا هو التعديل الأساسي لحل المشكلة.
      final result = await supabase!
          .from("notifications")
          .insert(mapNotifcation)
          .select();

      // طباعة النتيجة للتأكد من نجاح العملية.
      // إذا كان كل شيء على ما يرام، ستحتوي النتيجة على Map واحد.
      log("result result result ${result.toSet()}");

      log("notificationParent subabase end ");
    } catch (e) {
      log("notificationParent subabase throw ");
      throw Exception(e.toString());
    }
  }

  static Future<List<StudentsModel>> getParentChildren({
    required String parentId,
  }) async {
    List<StudentsModel> students;
    try {
      log("start getParentChildren");
      final response = await supabase!
          .from('students')
          .select()
          .eq("parent_id", parentId);
      log("response getStudents end ");

      if (response.isNotEmpty) {
        log("response not empty  ");

        students = response
            .map((student) => StudentsModelMapper.fromMap(student))
            .toList();

        return students;
      }
    } catch (e) {
      log("error in gettting getParentChildren $e");

      throw Exception("error in gettting childern $e");
    }
    return [];
  }
}

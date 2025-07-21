import 'dart:developer';

import 'package:my_little_route/models/buses/buses_model.dart';
import 'package:my_little_route/models/student/students_models.dart';
import 'package:my_little_route/models/user/user_model.dart';
import 'package:my_little_route/repository/supabase.dart';

class AppDataLayer {
  UserModel? user;
  // AppDataLayer(){
  //   getUser(GetIt.);
  // }
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
  Future<List<StudentsModel>>getStudens()async{
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
}

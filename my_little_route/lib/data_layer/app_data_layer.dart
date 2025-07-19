import 'dart:developer';

import 'package:my_little_route/models/user/user_model.dart';
import 'package:my_little_route/repository/supabase.dart';

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
}

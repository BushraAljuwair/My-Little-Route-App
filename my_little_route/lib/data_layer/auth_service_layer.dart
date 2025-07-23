import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServiceLayer {
  User? currentUser;
  AuthServiceLayer() {
    getCurrentUser();
  }
  void getCurrentUser() {
    try {
      log("get user in AuthServiceLayer start ");
      currentUser = Supabase.instance.client.auth.currentUser;
      log(currentUser.toString());
      log("get user in AuthServiceLayer end");
    } catch (e) {
      log("error when get user $e");
      throw FormatException("error when get user $e");
    }
  }

  String getAccressToken() {
    String result;
    try {
      log("get user in AuthServiceLayer start ");
      result = Supabase.instance.client.auth.currentSession!.accessToken;

      log(currentUser.toString());
      log("get user in AuthServiceLayer end");
    } catch (e) {
      log("error when get user $e");
      throw FormatException("error when get user $e");
    }
    return result;
  }
}

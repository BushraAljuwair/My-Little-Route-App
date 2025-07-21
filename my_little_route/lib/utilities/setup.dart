import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/data_layer/auth_layer.dart';
import 'package:my_little_route/data_layer/auth_service_layer.dart';
import 'package:my_little_route/repository/supabase.dart';
 import 'package:easy_localization/easy_localization.dart';

Future<void> setUp() async {
  // 1. Initialize Flutter binding and environment
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await SupabaseConnect.init();

  //  Register core services
  GetIt.I.registerSingleton<AuthLayer>(AuthLayer());
  GetIt.I.registerSingletonAsync<AuthServiceLayer>(
    () async => AuthServiceLayer(),
  );
  GetIt.I.registerSingletonAsync<AppDataLayer>(() async => AppDataLayer());
}

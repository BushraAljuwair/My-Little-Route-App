import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/data_layer/auth_service_layer.dart';
import 'package:my_little_route/models/user/user_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final auhtServivsesGetit = GetIt.I.get<AuthServiceLayer>();
  final appGetit = GetIt.I.get<AppDataLayer>();
  UserModel? user;
  HomeBloc() : super(HomeInitial()) {
    getUser();
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
  Future<void> getUser() async {
    try {
      log("start get user ");
      //
      log(auhtServivsesGetit.currentUser.toString());
      if (appGetit.user == null) {
        user = await appGetit.getUser(id: auhtServivsesGetit.currentUser!.id);
      } else {
        user = appGetit.user;
      }

      log("end get user ");
    } catch (e) {
      log("error in get user $e");
    }
  }
}

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/data_layer/auth_service_layer.dart';

part 'parent_home_event.dart';
part 'parent_home_state.dart';

class ParentHomeBloc extends Bloc<ParentHomeEvent, ParentHomeState> {
  final appGetIt = GetIt.I.get<AppDataLayer>();
  final authGetIt = GetIt.I.get<AuthServiceLayer>();
  ParentHomeBloc() : super(ParentHomeInitial()) {
    on<GetUserInfoEvent>((event, emit) async {
      try {
        log("home start");
        if (appGetIt.user == null) {
           await appGetIt.getUser(id: authGetIt.currentUser!.id);
        }
        log("home end");
        emit(SucssesState());
      } on Exception catch (e) {
        emit(ParentErrorState(message: e.toString()));
      }
    });
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/models/buses/buses_model.dart';
import 'package:my_little_route/models/user/user_model.dart';

part 'bus_event.dart';
part 'bus_state.dart';

class BusBloc extends Bloc<BusEvent, BusState> {
  final appGetit = GetIt.I.get<AppDataLayer>();
  List<UserModel>? drivers;
  List<BusesModel?>? buses;
  BusBloc() : super(BusInitial()) {
    on<BusEvent>((event, emit) {
      // TODO: implement event handler
    });
    //add(GetBusesEvent());
    on<GetBusesEvent>(getBusesMethod);
  }

  FutureOr<void> getBusesMethod(
    GetBusesEvent event,
    Emitter<BusState> emit,
  ) async {
    emit(LoadingState());
    try {
      buses = await appGetit.getBuses();
      drivers = await appGetit.getDrivers();
      emit(SuccessState());
    } catch (e) {
      log("error is $e");
      emit(ErrorState(message: "error is $e"));
    }
  }
}

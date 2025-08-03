import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/data_layer/auth_layer.dart';
import 'package:my_little_route/data_layer/auth_service_layer.dart';
import 'package:my_little_route/models/buses/buses_model.dart';
import 'package:my_little_route/models/user/user_model.dart';
import 'package:my_little_route/utilities/helper/updae_user_email.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'driver_profile_event.dart';
part 'driver_profile_state.dart';

class DriverProfileBloc extends Bloc<DriverProfileEvent, DriverProfileState> {
  final appGetit = GetIt.I.get<AppDataLayer>();
  final authLayerGetit = GetIt.I.get<AuthLayer>();
  final authServiceLGetit = GetIt.I.get<AuthServiceLayer>();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  final formKey = GlobalKey<FormState>();
  BusesModel? driverBus;

  var marker = HashSet<Marker>();
  LatLng? newDriverHouse;
  LatLng? cureentDriverHouse;

  DriverProfileBloc() : super(DriverProfileInitial()) {
    on<DriverProfileEvent>((event, emit) {});
    on<GetDriverBusInfoEvent>(getDriverBusInfoMthod);
    on<UpdateUserInfoEvent>(updateUserInfoMethd);
    on<UpdateMarkerLocationEvent>(onUpdateMarkerLocation);
    on<UpdateDriverLocationEvent>(updateDriverLocationMethod);
    on<LogOutEvent>(logOutMethod);
  }

  FutureOr<void> getDriverBusInfoMthod(
    GetDriverBusInfoEvent event,
    Emitter<DriverProfileState> emit,
  ) async {
    try {
      emit(LoadingState());
      log("bloc 1");
      if (appGetit.user == null) {
        await appGetit.getUser(id: authServiceLGetit.currentUser!.id);
      }
      driverBus = await appGetit.getBusForDriver(
        id: authServiceLGetit.currentUser!.id,
      );

      controllerName.text = appGetit.user!.name;
      controllerEmail.text = appGetit.user!.email;
      controllerPhone.text = appGetit.user!.phone;
      cureentDriverHouse = LatLng(
        appGetit.user!.latitude!,
        appGetit.user!.longitude!,
      );
      marker.add(
        Marker(
          markerId: const MarkerId('initialDriverLocation'),
          position: cureentDriverHouse!,
          infoWindow: const InfoWindow(title: "Your home location"),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );

      log("bloc 2");
      emit(SuccessState());
    } on Exception catch (e) {
      log("bloc 3");
      emit(ErorrState(message: e.toString()));
    }
  }

  FutureOr<void> updateUserInfoMethd(
    UpdateUserInfoEvent event,
    Emitter<DriverProfileState> emit,
  ) async {
    // emit(ProfileLoadingState());

    try {
      UserModel currentUser = appGetit.user!;
      if (currentUser.email != controllerEmail.text.trim()) {
        updateUserEmail(
          userId: currentUser.id!,
          newEmail: controllerEmail.text,
        );
      }
      log("userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      await appGetit.updateUserInfo(
        user: UserModel(
          id: appGetit.user!.id,
          email: controllerEmail.text,
          name: controllerName.text,
          phone: controllerPhone.text,
          role: appGetit.user!.role,
          createdAt: appGetit.user!.createdAt,
          latitude: appGetit.user!.latitude,
          longitude: appGetit.user!.longitude,
        ),
      );
      await appGetit.getUser(id: currentUser.id!);
      emit(SuccessState());
      log("User update failed: No user object in auth response.");
    } on AuthException catch (e) {
      log("AuthException during user info update: ${e.message}");
      emit(ErorrState(message: "Failed to update user info: ${e.message}"));
    } catch (e) {
      log("Unexpected error during user info update: $e");
      emit(ErorrState(message: "An unexpected error occurred: $e"));
    }
    controllerEmail.clear();
    controllerName.clear();
    controllerPhone.clear();
  }

  FutureOr<void> onUpdateMarkerLocation(
    UpdateMarkerLocationEvent event,
    Emitter<DriverProfileState> emit,
  ) {
    marker = HashSet<Marker>();
    cureentDriverHouse = event.newLocation;
    marker.add(
      Marker(
        markerId: MarkerId('selectedLocation'),
        position: cureentDriverHouse!,
        infoWindow: InfoWindow(title: "Selected Location"),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    emit(SuccessState());
  }

  FutureOr<void> updateDriverLocationMethod(
    UpdateDriverLocationEvent event,
    Emitter<DriverProfileState> emit,
  ) {
    try {
      log("1111111111111111111");
      appGetit.updateHuseLocation(
        id: appGetit.user!.id!,
        newLocation: cureentDriverHouse!,
      );
      log("444444444444444444");
    } catch (e) {
      log("88888888888888");

      emit(ErorrUpdateLocationState(message: e.toString()));
    }
  }

  FutureOr<void> logOutMethod(
    LogOutEvent event,
    Emitter<DriverProfileState> emit,
  ) async {
    try {
      await authLayerGetit.signOut();
      emit(SuccessStatesignOut());
    } catch (e) {
      emit(ErrorsignOut(message: e.toString()));
    }
  }
}

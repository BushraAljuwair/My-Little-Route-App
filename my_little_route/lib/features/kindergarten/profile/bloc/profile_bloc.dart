import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/data_layer/auth_layer.dart';
import 'package:my_little_route/data_layer/auth_service_layer.dart';
import 'package:my_little_route/models/user/user_model.dart';
import 'package:my_little_route/utilities/helper/updae_user_email.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  final authServiceGetit = GetIt.I.get<AuthServiceLayer>();
  final appGetit = GetIt.I.get<AppDataLayer>();
  final authGetit = GetIt.I.get<AuthLayer>();
  final formKey = GlobalKey<FormState>();

  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetUserEvent>(getUserMethod);
    on<AddAdminEvent>(addAdminEventMethod);
    on<SignOutEvent>(signOutMethod);
    on<UpdateUserInfoEvent>(updateUserInfoMethd);
  }

  FutureOr<void> getUserMethod(
    GetUserEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(LoadingState());
    try {
      if (appGetit.user == null) {
        await appGetit.getUser(id: authServiceGetit.currentUser!.id);
        emit(SuccessState());
      } else {
        emit(SuccessState());
      }
      controllerName.text = appGetit.user!.name;
      controllerEmail.text = appGetit.user!.email;
      controllerPhone.text = appGetit.user!.phone;
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  FutureOr<void> addAdminEventMethod(
    AddAdminEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(SuccessState());
  }

  FutureOr<void> signOutMethod(
    SignOutEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await authGetit.signOut();
      emit(SuccessLogOutState());
    } catch (e) {
      emit(ErrorLogOutState(message: e.toString()));
    }
  }

  FutureOr<void> updateUserInfoMethd(
    UpdateUserInfoEvent event,
    Emitter<ProfileState> emit,
  ) async {
    // emit(ProfileLoadingState());

    try {
     

      UserModel currentUser = appGetit.user!;
       updateUserEmail(userId: currentUser.id!,newEmail: controllerEmail.text);
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
     await  appGetit.getUser(id: currentUser.id!);
      emit(SuccessState());
      log("User update failed: No user object in auth response.");
      emit(
        ProfileErrorState(
          message: "User update failed: No user object in auth response.",
        ),
      );
      // }
    } on AuthException catch (e) {
      log("AuthException during user info update: ${e.message}");
      emit(
        ProfileErrorState(message: "Failed to update user info: ${e.message}"),
      );
    } catch (e) {
      log("Unexpected error during user info update: $e");
      emit(ProfileErrorState(message: "An unexpected error occurred: $e"));
    }
  }
}

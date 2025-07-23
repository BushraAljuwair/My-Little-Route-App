import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/data_layer/auth_layer.dart';
import 'package:my_little_route/data_layer/auth_service_layer.dart';
import 'package:my_little_route/features/auth/bloc/auth_bloc.dart';
import 'package:my_little_route/models/user/user_model.dart';
import 'package:my_little_route/utilities/helper/create_admin.dart';

part 'add_admin_event.dart';
part 'add_admin_state.dart';

class AddAdminBloc extends Bloc<AddAdminEvent, AddAdminState> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConformPassword = TextEditingController();
  bool isPasswordVisible = false;
  bool isSecure = true;
  final formKey = GlobalKey<FormState>();
  final appGetIt = GetIt.I.get<AppDataLayer>();
  final athServicsesGetIt = GetIt.I.get<AuthServiceLayer>();
  final authGetIt = GetIt.I.get<AuthLayer>();

  AddAdminBloc() : super(AddAdminInitial()) {
    on<AddAdminEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<TogglePasswordVisibilityEvent>(togglePasswordVisibilityMethod);
    on<AddNewAdminEvent>(addNewAdminMathod);
  }

  FutureOr<void> togglePasswordVisibilityMethod(
    TogglePasswordVisibilityEvent event,
    Emitter<AddAdminState> emit,
  ) {
    isSecure = !isSecure;
    isPasswordVisible = !isPasswordVisible;
    emit(TogglePasswordVisibilityState(isPasswordVisible: isPasswordVisible));
  }

  FutureOr<void> addNewAdminMathod(
    AddNewAdminEvent event,
    Emitter<AddAdminState> emit,
  ) async {
    // try {
    //   await appGetIt.addAdmin(
    //     user: UserModel(
    //       name: controllerName.text,
    //       email: controllerEmail.text,
    //       phone: controllerPhone.text,
    //       role: "admin",
    //     ),
    //     password: controllerPassword.text,
    //   );
    //   emit (SuccsessState());
    // } catch (e) {
    //   log("erorr ib bloc ");
    //   emit(ErrorInAddAdimnState(message: e.toString()));
    // }

    try {
      String? id = await createUser(
        controllerEmail.text,
        controllerPassword.text,
        athServicsesGetIt.getAccressToken(),
      );
      if (id != null && id.isNotEmpty) {
        authGetIt.addUserInUserTable(
          user: UserModel(
            id: id,
            name: controllerName.text,
            email: controllerEmail.text,
            phone: controllerPhone.text,
            role: "admin",
            createdAt: DateTime.now(),
            latitude: 24.5412682270113,
            longitude: 46.6648522263772,
          ),
        );
        controllerEmail.clear();
        controllerConformPassword.clear();
        controllerPassword.clear();
        controllerPhone.clear();
        controllerName.clear();

        emit(SuccsessState());
      }
    } on Exception catch (e) {
      emit(ErrorInAddAdimnState(message: e.toString()));
    }
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/data_layer/auth_layer.dart';
import 'package:my_little_route/models/user/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConformPassword = TextEditingController();
  bool isPasswordVisible = false;
  bool isSecure = true;
  final formKey = GlobalKey<FormState>();
  final authGetit = GetIt.I.get<AuthLayer>();
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<TogglePasswordVisibilityEvent>(togglePasswordVisibilityMethod);
    on<SignUPEvent>(signUPMethod);
    on<LogInEvent>(logInMethod);
  }

  FutureOr<void> togglePasswordVisibilityMethod(
    TogglePasswordVisibilityEvent event,
    Emitter<AuthState> emit,
  ) {
    isSecure = !isSecure;
    isPasswordVisible = !isPasswordVisible;
    emit(TogglePasswordVisibilityState(isPasswordVisible: isPasswordVisible));
  }

  FutureOr<void> signUPMethod(
    SignUPEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      log("bloc start  signUp");
      final resopnseId = await authGetit.signUp(
        email: controllerEmail.text,
        password: controllerPassword.text,
      );
      log("bloc end   signUp");
      log("bloc start reigistor user ");
      await authGetit.addUserInUserTable(
        user: UserModel(
          email: controllerEmail.text,
          name: controllerName.text,
          phone: controllerPhone.text,
          role: 'parent',
          id: resopnseId,
        ),
      );
      log("bloc endddddddddddddddddddddddddddddd ");
      emit(SignUpSatate());
    } catch (e) {
      log("bloc error in sign up $e ");
      emit(ErrorStatate(msg: "error in signUp $e"));
    }
  }

  FutureOr<void> logInMethod(LogInEvent event, Emitter<AuthState> emit) async {
    log("bloc start  log in ");
    try {
      await authGetit.logIn(
        email: controllerEmail.text,
        password: controllerPassword.text,
      );
        log("bloc end  log in ");
      emit(LogInStatate());
    } catch (e) {
      log("bloc error in sign up $e ");
      emit(ErrorStatate(msg: "error in log in  $e"));
    }
  }
}

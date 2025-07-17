import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConformPassword = TextEditingController();
  bool isPasswordVisible = false;
  bool isSecure=true;
  final formKey = GlobalKey<FormState>();
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<TogglePasswordVisibilityEvent>(togglePasswordVisibilityMethod);
  }

  FutureOr<void> togglePasswordVisibilityMethod(
    TogglePasswordVisibilityEvent event,
    Emitter<AuthState> emit,
  ) {
    isSecure=!isSecure;
    isPasswordVisible=!isPasswordVisible;
    emit(TogglePasswordVisibilityState(isPasswordVisible: isPasswordVisible));
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/features/driver/driver_current_trip_screen.dart';
import 'package:my_little_route/features/driver/driver_profile_screen.dart';
 

part 'nav_event.dart';
part 'nav_state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  List<Widget> screens = [
    DriverCurrentTripScreen(),
    DriverProfileScreen()
  ];
  int currenIndex = 0;
  NavBloc() : super(NavInitial()) {
    on<ChangeScreenDriverEvent>(changeScreenMethod);
  }

  FutureOr<void> changeScreenMethod(ChangeScreenDriverEvent event, Emitter<NavState> emit) {
    currenIndex=event.index;
    emit(NavInitial());
  }
}

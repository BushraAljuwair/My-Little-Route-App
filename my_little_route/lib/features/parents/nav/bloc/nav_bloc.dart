import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/features/driver/driver_trip/driver_trip_screen.dart';
import 'package:my_little_route/features/driver/driver_profile/driver_profile_screen.dart';
import 'package:my_little_route/features/parents/notification_screen.dart';
import 'package:my_little_route/features/parents/parent_profile_screen.dart';
import 'package:my_little_route/features/parents/parents_home_screen.dart';

part 'nav_event.dart';
part 'nav_state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  List<Widget> screens = [
    ParentsHomeScreen(),
    NotificationScreen(),
    ParentProfileScreen(),
  ];
  int currenIndex = 0;
  NavBloc() : super(NavInitial()) {
    on<ChangeScreenEvent>(changeScreenMethod);
  }

  FutureOr<void> changeScreenMethod(
    ChangeScreenEvent event,
    Emitter<NavState> emit,
  ) {
    currenIndex = event.index;
    emit(NavInitial());
  }
}

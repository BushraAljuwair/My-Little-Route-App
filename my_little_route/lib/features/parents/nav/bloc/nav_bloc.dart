import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/features/parents/notification_screen.dart';
import 'package:my_little_route/features/parents/parent_profile/parent_profile_screen.dart';
import 'package:my_little_route/features/parents/home/parents_home_screen.dart';
import 'package:my_little_route/features/parents/track_bus/track_bus_screen.dart';
import 'package:my_little_route/features/parents/tray_tracking/tray_tracking_screen.dart';

part 'nav_event.dart';
part 'nav_state.dart';

class ParentNavBloc extends Bloc<NavEvent, NavState> {
  List<Widget> screens = [
    // ParentsHomeScreen(),
    TrayTrackingScreen(),
    NotificationScreen(),
    ParentProfileScreen(),
  ];
  int currenIndex = 0;
  ParentNavBloc() : super(NavInitial()) {
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

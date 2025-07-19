import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/features/kindergarten/bus_screen.dart';
import 'package:my_little_route/features/kindergarten/children_screen.dart';
import 'package:my_little_route/features/kindergarten/home/home_screen.dart';
import 'package:my_little_route/features/kindergarten/profile_screen.dart';

part 'nav_event.dart';
part 'nav_state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  List<Widget> screens = [
    HomeScreen(),
    ChildrenScreen(),
    BusScreen(),
    ProfileScreen(),
  ];
  int currenIndex = 0;
  NavBloc() : super(NavInitial()) {
    on<ChangeScreenEvent>(changeScreenMethod);
  }

  FutureOr<void> changeScreenMethod(ChangeScreenEvent event, Emitter<NavState> emit) {
    currenIndex=event.index;
    emit(NavInitial());
  }
}

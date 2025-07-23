import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_little_route/features/nav/bloc/nav_bloc.dart';

class ParentNavScreen extends StatelessWidget {
  const ParentNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavBloc(),
      child: Builder(
        builder: (context) {
          final bloc = context.read<NavBloc>();
          return BlocBuilder<NavBloc, NavState>(
            builder: (context, state) {
              return Scaffold(
                body: bloc.screens[bloc.currenIndex],
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: bloc.currenIndex,
                  onTap: (value) {
                    log("value $value");
                    bloc.add(ChangeScreenEvent(index: value));
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: "home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notification_add_sharp),
                      label: "notifcation",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: "profile",
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

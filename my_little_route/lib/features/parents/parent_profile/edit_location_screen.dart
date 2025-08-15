import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
 import 'package:my_little_route/features/driver/driver_profile/widgets/alertdilog/location_confirmation_dialog.dart';
 import 'package:my_little_route/features/parents/parent_profile/bloc/parent_profile_bloc.dart';
  
class EditParentLocationScreen extends StatelessWidget {
  const EditParentLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ParentProfileBloc>();
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BlocBuilder<ParentProfileBloc, ParentProfileState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      zoom: 15,
                      target: bloc.cureentParentHouse!,
                    ),
                    onMapCreated: (controller) {
                      bloc.controller=controller;
                    },
                    onTap: (argument) {
                      bloc.add(
                        UpdateMarkerLocationEvent(newLocation: argument),
                      );
                      showAlertDilog(
                        context: context,
                        content: "doyou want to change your house ",
                        onConfirm: () {
                          bloc.add(UpdateLocationEvent());
                        },
                      );
                      log(":argumentargument  ${argument.toString()}");
                    },
                    markers: bloc.marker,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

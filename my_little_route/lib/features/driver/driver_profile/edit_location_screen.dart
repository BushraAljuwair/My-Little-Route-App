import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_little_route/features/driver/driver_profile/bloc/driver_profile_bloc.dart';
import 'package:my_little_route/features/driver/driver_profile/widgets/alertdilog/location_confirmation_dialog.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';

class EditLocationScreen extends StatelessWidget {
  const EditLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DriverProfileBloc>();
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BlocBuilder<DriverProfileBloc, DriverProfileState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      zoom: 15,
                      target: bloc.cureentDriverHouse!,
                    ),
                    onMapCreated: (controller) {},
                    onTap: (argument) {
                      bloc.add(
                        UpdateMarkerLocationEvent(newLocation: argument),
                      );
                      showAlertDilog(
                        context: context,
                        content: "doyou want to change your house ",
                        onConfirm: () {
                          bloc.add(UpdateDriverLocationEvent());
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

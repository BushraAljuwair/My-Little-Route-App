import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_little_route/features/parents/tray_tracking/bloc/tray_tracking_bloc.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_text.dart';

class TrayTrackingScreen extends StatelessWidget {
  const TrayTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrayTrackingBloc()..add(SetInitValuesEvent()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<TrayTrackingBloc>();
          return Scaffold(
            body: BlocBuilder<TrayTrackingBloc, TrayTrackingState>(
              builder: (context, state) {
                if (state is ErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: StyleColor.red,
                      content: Text(
                        state.message,
                        style: StyleText.bold18(context),
                      ),
                    ),
                  );
                }
                if (state is SucssesState) {
                  if (bloc.currentLocation == null) {
                    return Center(child: Text("current location error "));
                  }
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(bloc.currentLocation!.latitude!,
                          bloc.currentLocation!.longitude!),
                      zoom: 13.5,
                    ),
                    onMapCreated: (mapContollar) {
                      // NEW: We dispatch the new event here!
                      bloc.add(MapCreatedEvent(controller: mapContollar));
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId("source"),
                        position: bloc.sourceLocation,

                        icon: bloc.sourceIcon
                      ),
                      Marker(
                        markerId: MarkerId("destination"),
                        position: bloc.destination,
                         icon: bloc.destinationIcon
                      ),
                      Marker(
                        markerId: MarkerId("currentLocation"),
                        position: LatLng(bloc.currentLocation!.latitude!,
                            bloc.currentLocation!.longitude!),
                             icon: bloc.currentLocationIcon
                      ),
                    },
                    polylines: {
                      Polyline(
                        polylineId: PolylineId("route"),
                        points: bloc.polylineCoordinates,
                        color: StyleColor.buttonBlue,
                        width: 6,
                      ),
                    },
                  );
                }
                return Center(child: Text("wait please"));
              },
            ),
          );
        },
      ),
    );
  }
}

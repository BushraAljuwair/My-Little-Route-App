import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_little_route/features/parents/tracking/bloc/tracking_bloc.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/style/style_text.dart';
class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrackingBloc()..add(SetInitValuesEvent()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<TrackingBloc>();
          return Scaffold(
            body: BlocBuilder< TrackingBloc, TrackingState>(
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
                  // Ensure currentBusLocation is not null before displaying the map
                  if (bloc.currentBusLocation == null) {
                    return Center(child: Text("Bus location not available."));
                  }
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: bloc.currentBusLocation!,
                      zoom: 13.5,
                    ),
                    onMapCreated: (mapContollar) {
                      bloc.add(MapCreatedEvent(controller: mapContollar));
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId("source"),
                        position: bloc.sourceLocation!,
                        icon: bloc.sourceIcon,
                      ),
                      Marker(
                        markerId: MarkerId("destination"),
                        position: bloc.destination!,
                        icon: bloc.destinationIcon,
                      ),
                      // This marker will now track the bus location
                      Marker(
                        markerId: MarkerId("busLocation"),
                        position: bloc.currentBusLocation!,
                        icon: bloc.busIcon,
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

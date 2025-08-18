// File: lib/features/parents/track_bus/track_bus_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_little_route/features/parents/track_bus/bloc/track_bus_bloc.dart';
import 'package:my_little_route/style/style_color.dart';

class TrackBusScreen extends StatelessWidget {
  const TrackBusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrackBusBloc()..add(LoadInitialDataEvent()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<TrackBusBloc>();
          return Scaffold(
            appBar: AppBar(title: Text("تتبع الحافلة")),
            body: BlocBuilder<TrackBusBloc, TrackBusState>(
              builder: (context, state) {
                if (state is ErrorState) {
                  return Center(child: Text(state.message));
                }
                if (state is SuccessState) {
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      // استخدم موقع المستخدم الحالي كنقطة بداية
                      target: LatLng(bloc.locationData?.latitude ?? 0.0, bloc.locationData?.longitude ?? 0.0),
                      zoom: 13.5,
                    ),
                    markers: bloc.markers, // استخدم المجموعة المحدثة من bloc
                    onMapCreated: (controller) {
                      bloc.googleMapController.complete(controller);
                    },
                    polylines: bloc.polylines, // استخدم المجموعة المحدثة من bloc
                  );
                }
                return Center(child: Text("جاري التحميل..."));
              },
            ),
          );
        },
      ),
    );
  }
}

import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'tray_tracking_event.dart';
part 'tray_tracking_state.dart';

// ----- BLoC CODE -----
class TrayTrackingBloc extends Bloc<TrayTrackingEvent, TrayTrackingState> {
  final Completer<GoogleMapController> controllar = Completer();
  LatLng destination = LatLng(24.58431417429018, 46.64046150678661);
 
  LatLng sourceLocation = LatLng(24.53153838024201, 46.66579985162115);
  List<LatLng> polylineCoordinates = [];
  // device location
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  TrayTrackingBloc() : super(TrayTrackingInitial()) {
    on<TrayTrackingEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<SetInitValuesEvent>(setInitValuesMethod);
    // NEW: Handle map creation separately
    on<MapCreatedEvent>(_onMapCreated);
  }

  FutureOr<void> setInitValuesMethod(
    SetInitValuesEvent event,
    Emitter<TrayTrackingState> emit,
  ) async {
    try {
    await  _getIconsAndMarkers();
      PolylinePoints polylinePoints = PolylinePoints(
        apiKey: dotenv.env['googleMAp']!,
      );

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(
            sourceLocation.latitude,
            sourceLocation.longitude,
          ),

          destination: PointLatLng(destination.latitude, destination.longitude),
          mode: TravelMode.driving,
        ),
      );
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }

      // Get the current location ONCE, before the map is shown.
      await _getCureentLocation();
      // Emit success state AFTER getting the location.
      emit(SucssesState());
    } on Exception catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }

  Future<void> _getCureentLocation() async {
    Location location = Location();
    currentLocation = await location.getLocation();
    log("currentLocation ${currentLocation.toString()}");
  }

  // NEW: A separate handler for when the map is created.
  void _onMapCreated(MapCreatedEvent event, Emitter<TrayTrackingState> emit) {
    controllar.complete(event.controller);
    Location location = Location();

    // Now, listen for location changes to move the camera.
    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      event.controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 13.5,
            target: LatLng(newLoc.latitude!, newLoc.longitude!),
          ),
        ),
      );
       
    });
  }

  Future<void> _getIconsAndMarkers() async {
    final iconResult = await Future.wait([
      BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(50, 50)),
        "assets/image/bus-icon.png",
      ),
      BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(50, 50)),
        "assets/image/house.png",
      ),
    ]);
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
             
    destinationIcon = iconResult[1];
     currentLocationIcon = iconResult[0];
  }
}

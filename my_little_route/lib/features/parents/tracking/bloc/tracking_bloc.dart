// import 'dart:async';
// import 'dart:developer';
// import 'dart:ui';

// import 'package:bloc/bloc.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:get_it/get_it.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:meta/meta.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:my_little_route/data_layer/app_data_layer.dart';
// import 'package:my_little_route/data_layer/auth_service_layer.dart';
// import 'package:my_little_route/models/buses/buses_model.dart';
// import 'package:my_little_route/models/student/students_models.dart';
// import 'package:my_little_route/models/trip/trip_model.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// part 'tray_tracking_event.dart';
// part 'tray_tracking_state.dart';

// // ----- BLoC CODE -----
// class TrayTrackingBloc extends Bloc<TrayTrackingEvent, TrayTrackingState> {
//   final Completer<GoogleMapController> controllar = Completer();
//   // LatLng destination = LatLng(24.58431417429018, 46.64046150678661);
//   // LatLng sourceLocation = LatLng(24.53153838024201, 46.66579985162115);
//   LatLng schoolLocation = LatLng(24.580216, 46.671569);
//   LatLng? crrenLocation;
//   LatLng? sourceLocation;
//   LatLng destination = LatLng(24.580216, 46.671569);

//   List<LatLng> polylineCoordinates = [];
//   // device location
//   LocationData? currentLocation;
//   TripModel? trip;

//   BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

//   final appGetIt = GetIt.I.get<AppDataLayer>();
//   final authGetIt = GetIt.I.get<AuthServiceLayer>();

//   // Supabase client
//   final _supabase = Supabase.instance.client;

//   // The ID of the current trip and the bus
//   String? _currentTripId;
//   BusesModel? bus;
//   String? driverid;

//   // Stream subscription for real-time bus location updates
//   StreamSubscription<List<Map<String, dynamic>>>? _busLocationSubscription;

//   TrayTrackingBloc() : super(TrayTrackingInitial()) {
//     on<TrayTrackingEvent>((event, emit) {
//       // TODO: implement event handler
//     });
//     on<SetInitValuesEvent>(setInitValuesMethod);
//     // NEW: Handle map creation separately
//     on<MapCreatedEvent>(_onMapCreated);
//   }

//   FutureOr<void> setInitValuesMethod(
//     SetInitValuesEvent event,
//     Emitter<TrayTrackingState> emit,
//   ) async {
//     try {
//       await getChildAndBusAndDriverInfo();
//       await _getIconsAndMarkers();
//       PolylinePoints polylinePoints = PolylinePoints(
//         apiKey: dotenv.env['googleMAp']!,
//       );

//       PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         request: PolylineRequest(
//           origin: PointLatLng(
//             sourceLocation!.latitude,
//             sourceLocation!.longitude,
//           ),

//           destination: PointLatLng(destination.latitude, destination.longitude),
//           mode: TravelMode.driving,
//         ),
//       );
//       if (result.points.isNotEmpty) {
//         for (var point in result.points) {
//           polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//         }
//       }

//       // Get the current location ONCE, before the map is shown.
//       await _getCureentLocation();
//       // Emit success state AFTER getting the location.

//       emit(SucssesState());
//     } on Exception catch (e) {
//       emit(ErrorState(message: e.toString()));
//     }
//   }

//   Future<void> _getCureentLocation() async {
//     Location location = Location();
//     currentLocation = await location.getLocation();
//     log("currentLocation ${currentLocation.toString()}");
//   }

//   // NEW: A separate handler for when the map is created.
//   void _onMapCreated(MapCreatedEvent event, Emitter<TrayTrackingState> emit) {
//     controllar.complete(event.controller);
//     Location location = Location();

//     // Now, listen for location changes to move the camera.
//     location.onLocationChanged.listen((newLoc) {
//       currentLocation = newLoc;
//       event.controller.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             zoom: 13.5,
//             target: LatLng(newLoc.latitude!, newLoc.longitude!),
//           ),
//         ),
//       );
//     });
//   }

//   Future<void> _getIconsAndMarkers() async {
//     final iconResult = await Future.wait([
//       BitmapDescriptor.asset(
//         const ImageConfiguration(size: Size(50, 50)),
//         "assets/image/bus-icon.png",
//       ),
//       BitmapDescriptor.asset(
//         const ImageConfiguration(size: Size(50, 50)),
//         "assets/image/house.png",
//       ),
//       BitmapDescriptor.asset(
//         const ImageConfiguration(size: Size(50, 50)),
//         "assets/image/marker-Kindergarten.png",
//       ),
//     ]);
//     BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
//     currentLocationIcon = iconResult[0];
//     if (trip!.tripType == "pickup") {
//       sourceIcon = iconResult[1];
//       destinationIcon = iconResult[2];
//     } else {
//       sourceIcon = iconResult[2];
//       destinationIcon = iconResult[1];
//     }
//   }

//   Future<void> getChildAndBusAndDriverInfo() async {
//     try {
//       if (appGetIt.user == null) {
//         await appGetIt.getUser(id: authGetIt.currentUser!.id);
//       }

//       List<StudentsModel> childern = await appGetIt.getParentChildren(
//         parentId: appGetIt.user!.id!,
//       );
//       driverid = childern[0].driverId;
//       bus = await appGetIt.getBusForDriver(id: childern[0].driverId);
//       trip = await appGetIt.getCurrentTrip(busId: bus!.id!);
//       if (trip!.tripType == "pickup") {
//         sourceLocation = LatLng(childern[0].latitude!, childern[0].longitude!);
//         destination = schoolLocation;
//       } else {
//         sourceLocation = schoolLocation;
//         destination = LatLng(childern[0].latitude!, childern[0].longitude!);
//       }
//       log("trip ${trip.toString()}");
//       log("getCurrentLocationFromDB ib bloc ");
//       var location = await appGetIt.getCurrentLocationFromDB(busId: bus!.id!);
//       log(location.toString());
//       log("getCurrentLocationFromDB ib bloc ");
//     } on Exception catch (e) {
//       log("getChildAndBusAndDriverInfo() error $e");
//     }
//   }
// }
import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/data_layer/auth_service_layer.dart';
import 'package:my_little_route/models/buses/buses_model.dart';
import 'package:my_little_route/models/student/students_models.dart';
import 'package:my_little_route/models/trip/trip_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

// ----- BLoC CODE -----
class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final Completer<GoogleMapController> controllar = Completer();
  LatLng schoolLocation = LatLng(24.54138156897414, 46.66494298069781);
  LatLng? currentBusLocation;
  LatLng? sourceLocation;
  LatLng? destination;

  List<LatLng> polylineCoordinates = [];

  TripModel? trip;
  BusesModel? bus;
  String? driverid;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor busIcon = BitmapDescriptor.defaultMarker;

  final appGetIt = GetIt.I.get<AppDataLayer>();
  final authGetIt = GetIt.I.get<AuthServiceLayer>();

  StreamSubscription<dynamic>? busLocationSubscription;

  StreamSubscription<List<Map<String, dynamic>>>? _busLocationSubscription;

  TrackingBloc() : super(TrayTrackingInitial()) {
    on<SetInitValuesEvent>(setInitValuesMethod);
    on<BusLocationUpdatedEvent>(_onBusLocationUpdated);
    on<MapCreatedEvent>(_onMapCreated);
  }

  FutureOr<void> setInitValuesMethod(
    SetInitValuesEvent event,
    Emitter<TrackingState> emit,
  ) async {
    try {
      await getChildAndBusAndDriverInfo();
      await _getIconsAndMarkers();

      PolylinePoints polylinePoints = PolylinePoints(
        apiKey: dotenv.env['googleMAp']!,
      );

      // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      //   request: PolylineRequest(
      //     origin: PointLatLng(
      //       sourceLocation!.latitude,
      //       sourceLocation!.longitude,
      //     ),
      //     destination: PointLatLng(destination!.latitude, destination!.longitude),
      //     mode: TravelMode.driving,
      //   ),
      // );

      // if (result.points.isNotEmpty) {
      //   for (var point in result.points) {
      //     polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      //   }
      // }

      final busLocationStream =
          await appGetIt.getCurrentLocationFromDB(busId: bus!.id!)
              as Stream<List<Map<String, dynamic>>>;

      _busLocationSubscription = busLocationStream.listen((data) {
        if (data.isNotEmpty) {
          final lat = data[0]['latitude'];
          final lon = data[0]['longitude'];
          add(BusLocationUpdatedEvent(LatLng(lat, lon)));
        }
      });

      emit(SucssesState());
    } on Exception catch (e) {
      log("setInitValuesMethod error: ${e.toString()}");
      emit(ErrorState(message: e.toString()));
    }
  }

  // FutureOr<void> _onBusLocationUpdated(
  //     BusLocationUpdatedEvent event, Emitter<TrayTrackingState> emit) {
  //   currentBusLocation = event.newLocation;

  //   controllar.future.then((mapController) {
  //     mapController.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //           zoom: 13.5,
  //           target: currentBusLocation!,
  //         ),
  //       ),
  //     );
  //   });
  //   emit(SucssesState());
  // }
  FutureOr<void> _onBusLocationUpdated(
    BusLocationUpdatedEvent event,
    Emitter<TrackingState> emit,
  ) async {
    currentBusLocation = event.newLocation;

    // تحديث خط المسار كل مره يتحرك الباص
    polylineCoordinates.clear();

    PolylinePoints polylinePoints = PolylinePoints(
      apiKey: dotenv.env['googleMAp']!,
    );
    if (trip!.tripType == "pickup") {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(
            currentBusLocation!.latitude,
            currentBusLocation!.longitude,
          ),
          destination: PointLatLng(
            sourceLocation!.latitude,
            sourceLocation!.longitude,
          ),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }
    } else {
       PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(
            currentBusLocation!.latitude,
            currentBusLocation!.longitude,
          ),
          destination: PointLatLng(
            destination!.latitude,
            destination!.longitude,
          ),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }}
    }

    // حرك الكاميرا لموقع الباص
    controllar.future.then((mapController) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(zoom: 13.5, target: currentBusLocation!),
        ),
      );
    });

    emit(SucssesState());
  }

  void _onMapCreated(MapCreatedEvent event, Emitter<TrackingState> emit) {
    controllar.complete(event.controller);
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
      BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(50, 50)),
        "assets/image/marker-Kindergarten.png",
      ),
    ]);

    busIcon = iconResult[0];
    if (trip!.tripType == "pickup") {
      sourceIcon = iconResult[1];
      destinationIcon = iconResult[2];
    } else {
      sourceIcon = iconResult[2];
      destinationIcon = iconResult[1];
    }
  }

  Future<void> getChildAndBusAndDriverInfo() async {
    try {
      if (appGetIt.user == null) {
        await appGetIt.getUser(id: authGetIt.currentUser!.id);
      }

      List<StudentsModel> children = await appGetIt.getParentChildren(
        parentId: appGetIt.user!.id!,
      );
      driverid = children[0].driverId;
      bus = await appGetIt.getBusForDriver(id: children[0].driverId);
      trip = await appGetIt.getCurrentTrip(busId: bus!.id!);

      if (trip!.tripType == "pickup") {
        sourceLocation = LatLng(children[0].latitude!, children[0].longitude!);
        destination = schoolLocation;
      } else {
        sourceLocation = schoolLocation;
        destination = LatLng(children[0].latitude!, children[0].longitude!);
      }
      log("trip ${trip.toString()}");
    } on Exception catch (e) {
      log("getChildAndBusAndDriverInfo() error $e");
    }
  }

  @override
  Future<void> close() {
    _busLocationSubscription?.cancel();
    return super.close();
  }
}

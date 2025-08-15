// import 'dart:async';
// import 'dart:developer';

// import 'package:bloc/bloc.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:meta/meta.dart';
// import 'package:my_little_route/features/driver/driver_profile/bloc/driver_profile_bloc.dart';
// import 'package:my_little_route/style/style_color.dart';

// part 'track_bus_event.dart';
// part 'track_bus_state.dart';

// class TrackBusBloc extends Bloc<TrackBusEvent, TrackBusState> {
//   LatLng sourceLocation = LatLng(24.531841587266925, 46.66573800258332);
//   LatLng destinationLocation = LatLng(24.54140337386369, 46.66509543278269);

//   BitmapDescriptor busIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor houseIcon = BitmapDescriptor.defaultMarker;
//   Set<Marker> markers = {};
//   Completer<GoogleMapController> googleMapController = Completer();

//   final PolylinePoints polylinePoints = PolylinePoints(
//     apiKey: dotenv.env['googleMAp']!,
//   );

//   List<LatLng> polyPoints = [];
//   Set<Polyline> polylines = {};

//   Location location = Location();
//   LocationData? locationData;
//   StreamSubscription<LocationData>? locationSubscription;

//   TrackBusBloc() : super(TrackBusInitial()) {
//     on<LoadInitialDataEvent>(onLoadInitialDataMethod);
//     // on<GetPloyLineEvent>(getPloyLineMethod);
//     // on<LocationUpdatedEvent>(_onLocationUpdated);
//   }
//   FutureOr<void> onLoadInitialDataMethod(
//     LoadInitialDataEvent event,
//     Emitter<TrackBusState> emit,
//   ) async {
//     try {
//       emit(TrackBusLoading());

//       getCurrentLocation();
//       await _getIconsAndMarkers();

//       await getPolyLine();

//       emit(SuccessState());
//     } catch (e) {
//       emit(ErrorState(message: e.toString()));
//     }
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
//     ]);

//     busIcon = iconResult[0];
//     houseIcon = iconResult[1];
//   }

//   Future<void> getPolyLine() async {
//     try {
//       PolylineResult polylineResult = await polylinePoints
//           .getRouteBetweenCoordinates(
//             request: PolylineRequest(
//               origin: PointLatLng(
//                 sourceLocation.latitude,
//                 sourceLocation.longitude,
//               ),
//               destination: PointLatLng(
//                 destinationLocation.latitude,
//                 destinationLocation.longitude,
//               ),
//               mode: TravelMode.driving,
//               optimizeWaypoints: true,
//             ),
//           );
//       if (polylineResult.points.isNotEmpty) {
//         polyPoints = polylineResult.points
//             .map((points) => LatLng(points.latitude, points.longitude))
//             .toList();
//       }
//       emit(SuccessState());
//     } catch (e) {
//       print("--------------------------1");
//       print(e.toString());
//       emit(ErrorState(message: e.toString()));
//       print("-------------------------2");
//     }
//   }

//   Future<void> getCurrentLocation() async {
//     try {
//       locationData = await location.getLocation();

//       GoogleMapController controller = await googleMapController.future;
//       await controller.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: LatLng(locationData!.latitude!, locationData!.longitude!),
//             zoom: 14.5,
//             tilt: 59,
//             bearing: -70,
//           ),
//         ),
//       );
//       location.onLocationChanged.listen((LocationData newLocation) async {
//         await controller.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: LatLng(newLocation.latitude!, newLocation.longitude!),
//               zoom: 14.5,
//               tilt: 59,
//               bearing: -70,
//             ),
//           ),
//         );
//           locationData=newLocation;
//       });

//       emit(SuccessState());
//     } catch (e) {
//       emit(TrackBusError(message: e.toString()));
//     }
//   }
//   //   FutureOr<void> onLoadInitialDataMethod(
//   //     LoadInitialDataEvent event,
//   //     Emitter<TrackBusState> emit,
//   //   ) async {
//   //     emit(TrackBusLoading());
//   //     try {
//   //       if (!await _checkLocationPermissionAndService()) {
//   //         emit(TrackBusError(message: 'خدمات الموقع أو الأذونات غير متوفرة.'));
//   //         return;
//   //       }

//   //       await _getCurrentLocation();
//   //       await _getIconsAndMarkers();
//   //       _startLocationStream();

//   //       emit(TrackBusLoaded());
//   //     } catch (e) {
//   //       log(e.toString());
//   //       emit(TrackBusError(message: 'حدث خطأ: ${e.toString()}'));
//   //     }
//   //   }

//   //   Future<bool> _checkLocationPermissionAndService() async {
//   //     bool serviceEnabled = await location.serviceEnabled();
//   //     if (!serviceEnabled) {
//   //       serviceEnabled = await location.requestService();
//   //       if (!serviceEnabled) return false;
//   //     }

//   //     PermissionStatus permissionGranted = await location.hasPermission();
//   //     if (permissionGranted == PermissionStatus.denied) {
//   //       permissionGranted = await location.requestPermission();
//   //       if (permissionGranted != PermissionStatus.granted) return false;
//   //     }

//   //     return true;
//   //   }

//   //     if (locationData != null) {
//   //       markers.add(
//   //         Marker(
//   //           markerId: const MarkerId("currentLocation"),
//   //           position: LatLng(locationData!.latitude!, locationData!.longitude!),
//   //           icon: busIcon,
//   //         ),
//   //       );
//   //     }
//   //   }

//   //   Future<void> _getCurrentLocation() async {
//   //     locationData = await location.getLocation();
//   //   }

//   //   void _startLocationStream() {
//   //     locationSubscription = location.onLocationChanged.listen((newLocation) {
//   //       locationData = newLocation;

//   //       markers.removeWhere((m) => m.markerId.value == "currentLocation");
//   //       markers.add(
//   //         Marker(
//   //           markerId: const MarkerId("currentLocation"),
//   //           position: LatLng(newLocation.latitude!, newLocation.longitude!),
//   //           icon: busIcon,
//   //         ),
//   //       );

//   //       add(LocationUpdatedEvent(newLocation));
//   //     });
//   //   }

//   //   FutureOr<void> getPloyLineMethod(
//   //     GetPloyLineEvent event,
//   //     Emitter<TrackBusState> emit,
//   //   ) async {
//   //     try {
//   //       PolylineResult polylineResult = await polylinePoints.getRouteBetweenCoordinates(
//   //         request: PolylineRequest(
//   //           origin: PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//   //           destination: PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
//   //           mode: TravelMode.driving,
//   //           optimizeWaypoints: true,
//   //         ),
//   //       );

//   //       if (polylineResult.points.isNotEmpty) {
//   //         polyPoints = polylineResult.points
//   //             .map((point) => LatLng(point.latitude, point.longitude))
//   //             .toList();

//   //         polylines.add(
//   //           Polyline(
//   //             polylineId: const PolylineId('route'),
//   //             points: polyPoints,
//   //             color: StyleColor.blue,
//   //             width: 10,
//   //           ),
//   //         );
//   //       }

//   //       emit(TrackBusLoaded());
//   //     } catch (e) {
//   //       emit(TrackBusError(message: 'فشل في جلب المسار: ${e.toString()}'));
//   //     }
//   //   }

//   //   FutureOr<void> _onLocationUpdated(
//   //     LocationUpdatedEvent event,
//   //     Emitter<TrackBusState> emit,
//   //   ) {
//   //     animateCameraToCurrentLocation(event.locationData);
//   //     emit(TrackBusLocationUpdated(event.locationData));
//   //   }

//   //   void animateCameraToCurrentLocation(LocationData? newLocation) async {
//   //     if (newLocation != null && googleMapController.isCompleted) {
//   //       final GoogleMapController controller = await googleMapController.future;
//   //       await controller.animateCamera(
//   //         CameraUpdate.newCameraPosition(
//   //           CameraPosition(
//   //             target: LatLng(newLocation.latitude!, newLocation.longitude!),
//   //             zoom: 14.5,
//   //             tilt: 59,
//   //             bearing: -70,
//   //           ),
//   //         ),
//   //       );
//   //     }
//   //   }

//   //   @override
//   //   Future<void> close() {
//   //     locationSubscription?.cancel();
//   //     return super.close();
//   //   }
// }



// import 'dart:async';
// import 'dart:developer';

// import 'package:bloc/bloc.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:meta/meta.dart';
// import 'package:my_little_route/style/style_color.dart';

// part 'track_bus_event.dart';
// part 'track_bus_state.dart';

// class TrackBusBloc extends Bloc<TrackBusEvent, TrackBusState> {
//   // تم تغيير إحداثيات الموقع
//   LatLng sourceLocation = LatLng(24.531841587266925, 46.66573800258332);
//   LatLng destinationLocation = LatLng(24.54140337386369, 46.66509543278269);

//   BitmapDescriptor busIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor houseIcon = BitmapDescriptor.defaultMarker;
//   Set<Marker> markers = {};
//   Completer<GoogleMapController> googleMapController = Completer();

//   // تأكد من أن مفتاح API موجود في ملف .env
//   final PolylinePoints polylinePoints = PolylinePoints(
//     apiKey: dotenv.env['googleMAp']!,
//   );

//   List<LatLng> polyPoints = [];
//   Set<Polyline> polylines = {};

//   Location location = Location();
//   LocationData? locationData;
//   StreamSubscription<LocationData>? locationSubscription;

//   TrackBusBloc() : super(TrackBusInitial()) {
//     on<LoadInitialDataEvent>(onLoadInitialDataMethod);
//     // يمكنك إضافة معالجات للأحداث الأخرى هنا إذا لزم الأمر
//   }

//   FutureOr<void> onLoadInitialDataMethod(
//     LoadInitialDataEvent event,
//     Emitter<TrackBusState> emit,
//   ) async {
//     try {
//       emit(TrackBusLoading());

//       // خطوة 1: التحقق من أذونات الموقع
//       if (!await _checkAndRequestLocationPermissions(emit)) {
//         // إذا لم يتم منح الأذونات، نخرج من الدالة
//         return;
//       }
      
//       // خطوة 2: استدعاء جلب الأيقونات والماركرز أولاً
//       await _getIconsAndMarkers();
      
//       // خطوة 3: استدعاء جلب الموقع الحالي وتحديث الماركر الخاص به
//       await getCurrentLocation(emit);
      
//       // خطوة 4: استدعاء جلب المسار بعد التأكد من وجود الموقعين
//       await getPolyLine(emit);

//       // إذا نجحت جميع الخطوات، ننتقل إلى حالة النجاح
//       emit(SuccessState());
//     } catch (e, stacktrace) {
//       log("An error occurred: $e", name: "TrackBusBloc", stackTrace: stacktrace);
//       emit(ErrorState(message: e.toString()));
//     }
//   }

//   Future<bool> _checkAndRequestLocationPermissions(Emitter<TrackBusState> emit) async {
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;

//     // تحقق مما إذا كانت خدمة الموقع مفعلة
//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         emit(ErrorState(message: "Location services are disabled. Please enable them."));
//         return false;
//       }
//     }

//     // تحقق من أذونات الموقع
//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         emit(ErrorState(message: "Location permissions are denied. The app cannot function without them."));
//         return false;
//       }
//     }
//     return true;
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
//     ]);

//     busIcon = iconResult[0];
//     houseIcon = iconResult[1];

//     // إضافة ماركر الوجهة
//     markers.add(
//       Marker(
//         markerId: const MarkerId("destination"),
//         position: destinationLocation,
//         icon: houseIcon,
//       ),
//     );
    
//     // إضافة ماركر المصدر (الباص) هنا
//     markers.add(
//       Marker(
//         markerId: const MarkerId("source"),
//         position: sourceLocation,
//         icon: busIcon,
//       ),
//     );
//   }

//   Future<void> getPolyLine(Emitter<TrackBusState> emit) async {
//     try {
//       PolylineResult polylineResult = await polylinePoints
//           .getRouteBetweenCoordinates(
//             request: PolylineRequest(
//               origin: PointLatLng(
//                 sourceLocation.latitude,
//                 sourceLocation.longitude,
//               ),
//               destination: PointLatLng(
//                 destinationLocation.latitude,
//                 destinationLocation.longitude,
//               ),
//               mode: TravelMode.driving,
//               optimizeWaypoints: true,
//             ),
//           );
//       if (polylineResult.points.isNotEmpty) {
//         polyPoints = polylineResult.points
//             .map((points) => LatLng(points.latitude, points.longitude))
//             .toList();
//         polylines.add(
//           Polyline(
//             polylineId: PolylineId("route"),
//             points: polyPoints,
//             color: StyleColor.blue,
//             width: 5,
//           ),
//         );
//       } else {
//         log("No polyline points found. Check API key and coordinates.", name: "getPolyLine");
//       }
//     } catch (e, stacktrace) {
//       log("Error fetching polyline: $e", name: "getPolyLine", stackTrace: stacktrace);
//       emit(ErrorState(message: "Failed to get route. Please check your API key and network connection."));
//     }
//   }

//   Future<void> getCurrentLocation(Emitter<TrackBusState> emit) async {
//     try {
//       locationData = await location.getLocation();
      
//       // تحديث marker الموقع الحالي
//       markers.add(
//         Marker(
//           markerId: const MarkerId("currentLocation"),
//           position: LatLng(locationData!.latitude!, locationData!.longitude!),
//           icon: BitmapDescriptor.defaultMarker, // استخدم أيقونة افتراضية لموقعك الحالي
//         ),
//       );

//       // تأكد من أن الـ controller جاهز قبل استخدامه
//       if (!googleMapController.isCompleted) {
//         log("GoogleMapController is not yet complete. Skipping camera animation.", name: "getCurrentLocation");
//         // لا تحاول استخدام الـ controller إذا لم يكن جاهزًا
//       } else {
//         GoogleMapController controller = await googleMapController.future;
//         await controller.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: LatLng(locationData!.latitude!, locationData!.longitude!),
//               zoom: 14.5,
//               tilt: 59,
//               bearing: -70,
//             ),
//           ),
//         );
//       }
      
//       // الاستماع لتغييرات الموقع
//       locationSubscription?.cancel(); // ألغِ الاشتراك القديم لتجنب التكرار
//       locationSubscription = location.onLocationChanged.listen((LocationData newLocation) async {
//         if (googleMapController.isCompleted) {
//           GoogleMapController controller = await googleMapController.future;
//           await controller.animateCamera(
//             CameraUpdate.newCameraPosition(
//               CameraPosition(
//                 target: LatLng(newLocation.latitude!, newLocation.longitude!),
//                 zoom: 14.5,
//                 tilt: 59,
//                 bearing: -70,
//               ),
//             ),
//           );
//         }
        
//         // تحديث locationData و markers هنا
//         locationData = newLocation;
//         markers.removeWhere((m) => m.markerId.value == "currentLocation");
//         markers.add(
//           Marker(
//             markerId: const MarkerId("currentLocation"),
//             position: LatLng(newLocation.latitude!, newLocation.longitude!),
//             icon: BitmapDescriptor.defaultMarker, // استخدم أيقونة افتراضية
//           ),
//         );
//       });
//     } catch (e, stacktrace) {
//       log("Error getting current location: $e", name: "getCurrentLocation", stackTrace: stacktrace);
//       emit(ErrorState(message: "Failed to get your current location. Please ensure location services are enabled."));
//     }
//   }

//   @override
//   Future<void> close() {
//     locationSubscription?.cancel();
//     return super.close();
//   }
// }


import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/style/style_color.dart';

part 'track_bus_event.dart';
part 'track_bus_state.dart';

class TrackBusBloc extends Bloc<TrackBusEvent, TrackBusState> {
  // Coordinates for the source and destination locations
  LatLng sourceLocation = LatLng(24.531841587266925, 46.66573800258332);
  LatLng destinationLocation = LatLng(24.54140337386369, 46.66509543278269);

  // Marker icons
  BitmapDescriptor busIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor houseIcon = BitmapDescriptor.defaultMarker;
  Set<Marker> markers = {};
  Completer<GoogleMapController> googleMapController = Completer();

  // Polyline services
  final PolylinePoints polylinePoints = PolylinePoints(
    apiKey: dotenv.env['googleMAp']!,
  );

  List<LatLng> polyPoints = [];
  Set<Polyline> polylines = {};

  // Location services for the user
  Location location = Location();
  LocationData? locationData;
  StreamSubscription<LocationData>? locationSubscription;

  // Timer for bus movement simulation
  Timer? busMovementTimer;
  int busPositionIndex = 0;

  TrackBusBloc() : super(TrackBusInitial()) {
    on<LoadInitialDataEvent>(onLoadInitialDataMethod);
    on<MoveBusEvent>(onMoveBusMethod);
  }

  FutureOr<void> onLoadInitialDataMethod(
    LoadInitialDataEvent event,
    Emitter<TrackBusState> emit,
  ) async {
    try {
      emit(TrackBusLoading());

      // Step 1: Check and request location permissions
      if (!await _checkAndRequestLocationPermissions(emit)) {
        return;
      }
      
      // Step 2: Get icons and create static markers
      await _getIconsAndMarkers();
      
      // Step 3: Get user's current location and add marker
      await getCurrentLocation(emit);
      
      // Step 4: Get polyline for the bus route
      await getPolyLine(emit);

      // Start the bus movement timer after all data is loaded
      startBusMovement();

      emit(SuccessState());
    } catch (e, stacktrace) {
      log("An error occurred: $e", name: "TrackBusBloc", stackTrace: stacktrace);
      emit(ErrorState(message: e.toString()));
    }
  }

  FutureOr<void> onMoveBusMethod(
    MoveBusEvent event,
    Emitter<TrackBusState> emit,
  ) async {
    if (polyPoints.isEmpty) return;

    // Check if the bus has reached the destination
    if (busPositionIndex >= polyPoints.length) {
      busMovementTimer?.cancel();
      log("Bus reached destination!", name: "BusMovement");
      return;
    }

    // Get the new bus position from the polyline points
    LatLng newBusPosition = polyPoints[busPositionIndex];
    busPositionIndex++;

    // Remove old bus marker and add new one
    markers.removeWhere((marker) => marker.markerId.value == "source");
    markers.add(
      Marker(
        markerId: const MarkerId("source"),
        position: newBusPosition,
        icon: busIcon,
      ),
    );

    // Animate the camera to follow the bus
    if (googleMapController.isCompleted) {
      GoogleMapController controller = await googleMapController.future;
      await controller.animateCamera(
        CameraUpdate.newLatLng(newBusPosition),
      );
    }

    emit(SuccessState());
  }

  void startBusMovement() {
    busMovementTimer?.cancel(); // Cancel any existing timer
    busMovementTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      add(MoveBusEvent());
    });
  }

  Future<bool> _checkAndRequestLocationPermissions(Emitter<TrackBusState> emit) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        emit(ErrorState(message: "Location services are disabled. Please enable them."));
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        emit(ErrorState(message: "Location permissions are denied. The app cannot function without them."));
        return false;
      }
    }
    return true;
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

    busIcon = iconResult[0];
    houseIcon = iconResult[1];

    markers.add(
      Marker(
        markerId: const MarkerId("destination"),
        position: destinationLocation,
        icon: houseIcon,
      ),
    );
  }

  Future<void> getPolyLine(Emitter<TrackBusState> emit) async {
    try {
      PolylineResult polylineResult = await polylinePoints
          .getRouteBetweenCoordinates(
            request: PolylineRequest(
              origin: PointLatLng(
                sourceLocation.latitude,
                sourceLocation.longitude,
              ),
              destination: PointLatLng(
                destinationLocation.latitude,
                destinationLocation.longitude,
              ),
              mode: TravelMode.driving,
              optimizeWaypoints: true,
            ),
          );
      if (polylineResult.points.isNotEmpty) {
        polyPoints = polylineResult.points
            .map((points) => LatLng(points.latitude, points.longitude))
            .toList();
        polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            points: polyPoints,
            color: StyleColor.blue,
            width: 5,
          ),
        );
      } else {
        log("No polyline points found. Check API key and coordinates.", name: "getPolyLine");
      }
    } catch (e, stacktrace) {
      log("Error fetching polyline: $e", name: "getPolyLine", stackTrace: stacktrace);
      emit(ErrorState(message: "Failed to get route. Please check your API key and network connection."));
    }
  }

  Future<void> getCurrentLocation(Emitter<TrackBusState> emit) async {
    try {
      locationData = await location.getLocation();
      
      // Update the user's current location marker
      markers.add(
        Marker(
          markerId: const MarkerId("currentLocation"),
          position: LatLng(locationData!.latitude!, locationData!.longitude!),
          icon: BitmapDescriptor.defaultMarker, // Use a default icon for the user
        ),
      );
      
      locationSubscription?.cancel();
      locationSubscription = location.onLocationChanged.listen((LocationData newLocation) async {
        locationData = newLocation;
        markers.removeWhere((m) => m.markerId.value == "currentLocation");
        markers.add(
          Marker(
            markerId: const MarkerId("currentLocation"),
            position: LatLng(newLocation.latitude!, newLocation.longitude!),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      });
    } catch (e, stacktrace) {
      log("Error getting current location: $e", name: "getCurrentLocation", stackTrace: stacktrace);
      emit(ErrorState(message: "Failed to get your current location. Please ensure location services are enabled."));
    }
  }

  @override
  Future<void> close() {
    busMovementTimer?.cancel();
    locationSubscription?.cancel();
    return super.close();
  }
}

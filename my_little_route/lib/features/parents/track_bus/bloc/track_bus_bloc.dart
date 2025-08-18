// // import 'dart:async';
// // import 'dart:developer';

// // import 'package:bloc/bloc.dart';
// // import 'package:flutter/widgets.dart';
// // import 'package:flutter_dotenv/flutter_dotenv.dart';
// // import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:location/location.dart';
// // import 'package:meta/meta.dart';
// // import 'package:my_little_route/style/style_color.dart';

// // part 'track_bus_event.dart';
// // part 'track_bus_state.dart';

// // class TrackBusBloc extends Bloc<TrackBusEvent, TrackBusState> {
// //   // Coordinates for the source and destination locations
// //   LatLng sourceLocation = LatLng(24.531841587266925, 46.66573800258332);
// //   LatLng destinationLocation = LatLng(24.54140337386369, 46.66509543278269);

// //   // Marker icons
// //   BitmapDescriptor busIcon = BitmapDescriptor.defaultMarker;
// //   BitmapDescriptor houseIcon = BitmapDescriptor.defaultMarker;
// //   Set<Marker> markers = {};
// //   Completer<GoogleMapController> googleMapController = Completer();

// //   // Polyline services
// //   final PolylinePoints polylinePoints = PolylinePoints(
// //     apiKey: dotenv.env['googleMAp']!,
// //   );

// //   List<LatLng> polyPoints = [];
// //   Set<Polyline> polylines = {};

// //   // Location services for the user
// //   Location location = Location();
// //   LocationData? locationData;
// //   StreamSubscription<LocationData>? locationSubscription;

// //   // Timer for bus movement simulation
// //   Timer? busMovementTimer;
// //   int busPositionIndex = 0;

// //   TrackBusBloc() : super(TrackBusInitial()) {
// //     on<LoadInitialDataEvent>(onLoadInitialDataMethod);
// //     on<MoveBusEvent>(onMoveBusMethod);
// //   }

// //   FutureOr<void> onLoadInitialDataMethod(
// //     LoadInitialDataEvent event,
// //     Emitter<TrackBusState> emit,
// //   ) async {
// //     try {
// //       emit(TrackBusLoading());

// //       // Step 1: Check and request location permissions
// //       if (!await _checkAndRequestLocationPermissions(emit)) {
// //         return;
// //       }

// //       // Step 2: Get icons and create static markers
// //       await _getIconsAndMarkers();

// //       // Step 3: Get user's current location and add marker
// //       await getCurrentLocation(emit);

// //       // Step 4: Get polyline for the bus route
// //       await getPolyLine(emit);

// //       // Start the bus movement timer after all data is loaded
// //       startBusMovement();

// //       emit(SuccessState());
// //     } catch (e, stacktrace) {
// //       log("An error occurred: $e", name: "TrackBusBloc", stackTrace: stacktrace);
// //       emit(ErrorState(message: e.toString()));
// //     }
// //   }

// //   FutureOr<void> onMoveBusMethod(
// //     MoveBusEvent event,
// //     Emitter<TrackBusState> emit,
// //   ) async {
// //     if (polyPoints.isEmpty) return;

// //     // Check if the bus has reached the destination
// //     if (busPositionIndex >= polyPoints.length) {
// //       busMovementTimer?.cancel();
// //       log("Bus reached destination!", name: "BusMovement");
// //       return;
// //     }

// //     // Get the new bus position from the polyline points
// //     LatLng newBusPosition = polyPoints[busPositionIndex];
// //     busPositionIndex++;

// //     // Remove old bus marker and add new one
// //     markers.removeWhere((marker) => marker.markerId.value == "source");
// //     markers.add(
// //       Marker(
// //         markerId: const MarkerId("source"),
// //         position: newBusPosition,
// //         icon: busIcon,
// //       ),
// //     );

// //     // Animate the camera to follow the bus
// //     if (googleMapController.isCompleted) {
// //       GoogleMapController controller = await googleMapController.future;
// //       await controller.animateCamera(
// //         CameraUpdate.newLatLng(newBusPosition),
// //       );
// //     }

// //     emit(SuccessState());
// //   }

// //   void startBusMovement() {
// //     busMovementTimer?.cancel(); // Cancel any existing timer
// //     busMovementTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
// //       add(MoveBusEvent());
// //     });
// //   }

// //   Future<bool> _checkAndRequestLocationPermissions(Emitter<TrackBusState> emit) async {
// //     bool serviceEnabled;
// //     PermissionStatus permissionGranted;

// //     serviceEnabled = await location.serviceEnabled();
// //     if (!serviceEnabled) {
// //       serviceEnabled = await location.requestService();
// //       if (!serviceEnabled) {
// //         emit(ErrorState(message: "Location services are disabled. Please enable them."));
// //         return false;
// //       }
// //     }

// //     permissionGranted = await location.hasPermission();
// //     if (permissionGranted == PermissionStatus.denied) {
// //       permissionGranted = await location.requestPermission();
// //       if (permissionGranted != PermissionStatus.granted) {
// //         emit(ErrorState(message: "Location permissions are denied. The app cannot function without them."));
// //         return false;
// //       }
// //     }
// //     return true;
// //   }

// //   Future<void> _getIconsAndMarkers() async {
// //     final iconResult = await Future.wait([
// //       BitmapDescriptor.asset(
// //         const ImageConfiguration(size: Size(50, 50)),
// //         "assets/image/bus-icon.png",
// //       ),
// //       BitmapDescriptor.asset(
// //         const ImageConfiguration(size: Size(50, 50)),
// //         "assets/image/house.png",
// //       ),
// //     ]);

// //     busIcon = iconResult[0];
// //     houseIcon = iconResult[1];

// //     markers.add(
// //       Marker(
// //         markerId: const MarkerId("destination"),
// //         position: destinationLocation,
// //         icon: houseIcon,
// //       ),
// //     );
// //   }

// //   Future<void> getPolyLine(Emitter<TrackBusState> emit) async {
// //     try {
// //       PolylineResult polylineResult = await polylinePoints
// //           .getRouteBetweenCoordinates(
// //             request: PolylineRequest(
// //               origin: PointLatLng(
// //                 sourceLocation.latitude,
// //                 sourceLocation.longitude,
// //               ),
// //               destination: PointLatLng(
// //                 destinationLocation.latitude,
// //                 destinationLocation.longitude,
// //               ),
// //               mode: TravelMode.driving,
// //               optimizeWaypoints: true,
// //             ),
// //           );
// //       if (polylineResult.points.isNotEmpty) {
// //         polyPoints = polylineResult.points
// //             .map((points) => LatLng(points.latitude, points.longitude))
// //             .toList();
// //         polylines.add(
// //           Polyline(
// //             polylineId: PolylineId("route"),
// //             points: polyPoints,
// //             color: StyleColor.blue,
// //             width: 5,
// //           ),
// //         );
// //       } else {
// //         log("No polyline points found. Check API key and coordinates.", name: "getPolyLine");
// //       }
// //     } catch (e, stacktrace) {
// //       log("Error fetching polyline: $e", name: "getPolyLine", stackTrace: stacktrace);
// //       emit(ErrorState(message: "Failed to get route. Please check your API key and network connection."));
// //     }
// //   }

// //   Future<void> getCurrentLocation(Emitter<TrackBusState> emit) async {
// //     try {
// //       locationData = await location.getLocation();

// //       // Update the user's current location marker
// //       markers.add(
// //         Marker(
// //           markerId: const MarkerId("currentLocation"),
// //           position: LatLng(locationData!.latitude!, locationData!.longitude!),
// //           icon: BitmapDescriptor.defaultMarker, // Use a default icon for the user
// //         ),
// //       );

// //       locationSubscription?.cancel();
// //       locationSubscription = location.onLocationChanged.listen((LocationData newLocation) async {
// //         locationData = newLocation;
// //         markers.removeWhere((m) => m.markerId.value == "currentLocation");
// //         markers.add(
// //           Marker(
// //             markerId: const MarkerId("currentLocation"),
// //             position: LatLng(newLocation.latitude!, newLocation.longitude!),
// //             icon: BitmapDescriptor.defaultMarker,
// //           ),
// //         );
// //       });
// //     } catch (e, stacktrace) {
// //       log("Error getting current location: $e", name: "getCurrentLocation", stackTrace: stacktrace);
// //       emit(ErrorState(message: "Failed to get your current location. Please ensure location services are enabled."));
// //     }
// //   }

// //   @override
// //   Future<void> close() {
// //     busMovementTimer?.cancel();
// //     locationSubscription?.cancel();
// //     return super.close();
// //   }
// // }

// import 'dart:async';
// import 'dart:developer';

// import 'package:bloc/bloc.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:get_it/get_it.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:meta/meta.dart';
// import 'package:my_little_route/data_layer/app_data_layer.dart';
// import 'package:my_little_route/data_layer/auth_layer.dart';
// import 'package:my_little_route/data_layer/auth_service_layer.dart';
// import 'package:my_little_route/models/buses/buses_model.dart';
// import 'package:my_little_route/models/student/students_models.dart';
// import 'package:my_little_route/models/user/user_model.dart';
// import 'package:my_little_route/style/style_color.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// part 'track_bus_event.dart';
// part 'track_bus_state.dart';

// class TrackBusBloc extends Bloc<TrackBusEvent, TrackBusState> {
//   //Coordinates for the destination location
//   LatLng destinationLocation = LatLng(24.54140337386369, 46.66509543278269);

//   // Marker icons and set
//   BitmapDescriptor busIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor houseIcon = BitmapDescriptor.defaultMarker;
//   Set<Marker> markers = {};
//   Completer<GoogleMapController> googleMapController = Completer();

//   // Supabase client
//   final _supabase = Supabase.instance.client;

//   // The ID of the current trip and the bus
//   String? _currentTripId;
//   String? _busId;

//   // Stream subscription for real-time bus location updates
//   StreamSubscription<List<Map<String, dynamic>>>? _busLocationSubscription;

//   // Polyline services
//   final PolylinePoints polylinePoints = PolylinePoints(
//     apiKey: dotenv.env['googleMAp']!,
//   );

//   List<LatLng> polyPoints = [];
//   Set<Polyline> polylines = {};

//   // Location services for the user
//   Location location = Location();
//   LocationData? locationData;
//   StreamSubscription<LocationData>? locationSubscription;

//   List<StudentsModel>? childern;
//   BusesModel ?bus;

//   final appGetit = GetIt.I.get<AppDataLayer>();
//   final authLayerGetit = GetIt.I.get<AuthLayer>();
//   final authServiceLGetit = GetIt.I.get<AuthServiceLayer>();

//   TrackBusBloc() : super(TrackBusInitial()) {
//     on<LoadInitialDataEvent>(onLoadInitialDataMethod);
//   }

//   FutureOr<void> onLoadInitialDataMethod(
//     LoadInitialDataEvent event,
//     Emitter<TrackBusState> emit,
//   ) async {
//     try {
//       emit(TrackBusLoading());

//       // Step 1: Check and request location permissions
//       if (!await _checkAndRequestLocationPermissions(emit)) {
//         return;
//       }

//       childern = await appGetit.getParentChildren(parentId: appGetit.user!.id!);
//       List<UserModel>? drivers = await appGetit.getDrivers();
//      UserModel driver = drivers.firstWhere((driver) {
//         return driver.id == childern![0].driverId;
//       });
      
//      bus=await  appGetit.getBusForDriver(id: driver.id!);
//       if(childern==null || childern!.isEmpty){
//         return ;
//       }
//       // Step 2: Get icons and create static markers
//       await _getIconsAndMarkers();

//       // Step 3: Get today's trip ID and bus ID based on the student
//       // TODO: يجب عليك استبدال هذا بمعرف الطالب الحقيقي المرتبط بالحساب الحالي.
//       // يمكنك جلب هذا المعرف من قاعدة البيانات أو من حالة تسجيل الدخول.
//       // final String studentId = "STUDENT_ID_HERE";

//       await _fetchTodayTrip(emit, childern![0].id!);

//       // Step 4: Start real-time location listening
//       _startBusLocationStream(emit);

//       // Step 5: Get user's current location and add marker
//       await getCurrentLocation(emit);

//       // Step 6: Get polyline for the bus route (needs bus location)
//       await getPolyLine(emit);

//       emit(SuccessState());
//     } catch (e, stacktrace) {
//       log(
//         "An error occurred: $e",
//         name: "TrackBusBloc",
//         stackTrace: stacktrace,
//       );
//       emit(ErrorState(message: e.toString()));
//     }
//   }

//   // Gets the current day's trip and its bus ID from the database, linked to a specific student
//   Future<void> _fetchTodayTrip(
//     Emitter<TrackBusState> emit,
//     String studentId,
//   ) async {
//     try {
//       final now = DateTime.now();
//       final tripType = now.hour < 12
//           ? 'pickup'
//           : 'dropoff'; // Determine if it's morning or afternoon

//       // Query for the active trip for today, linked to a specific student
//       final response = await _supabase
//           .from('trips')
//           .select('id, bus_id, students!inner(id)') // Join with students table
//           .eq('trip_type', tripType)
//           .eq('is_completed', false) // Make sure the trip is not completed
//           .gte(
//             'scheduled_time',
//             DateTime(now.year, now.month, now.day),
//           ) // Trip starts today
//           .lt(
//             'scheduled_time',
//             DateTime(now.year, now.month, now.day + 1),
//           ) // Trip ends today
//           .eq('students.id', studentId) // Filter by the specific student ID
//           .single();

//       _currentTripId = response['id'];
//       _busId = response['bus_id'];
//       log(
//         "Found trip ID: $_currentTripId with bus ID: $_busId",
//         name: "Trip Fetch",
//       );
//     } on PostgrestException catch (e) {
//       log("PostgrestError fetching trip: $e", name: "SupabaseError");
//       emit(
//         ErrorState(
//           message:
//               "Failed to find today's active trip for this student. Please check trip data in the database.",
//         ),
//       );
//     } catch (e) {
//       log("General error fetching trip: $e", name: "Trip Fetch Error");
//       emit(
//         ErrorState(
//           message: "An unexpected error occurred while fetching trip data.",
//         ),
//       );
//     }
//   }

//   // Starts the real-time listener for the bus's location
//   void _startBusLocationStream(Emitter<TrackBusState> emit) {
//     if (_busId == null) {
//       log("Bus ID is null, cannot start stream.", name: "Stream Error");
//       emit(ErrorState(message: "Failed to find bus for today's trip."));
//       return;
//     }

//     // Cancel existing stream to prevent multiple listeners
//     _busLocationSubscription?.cancel();

//     // Call the new function to get the stream and start listening to it
//     _busLocationSubscription = getParentBusLocation().listen(
//       (data) async {
//         if (data.isNotEmpty) {
//           final latestLocation = data.first;
//           final newLat = latestLocation['latitude'] as double;
//           final newLng = latestLocation['longitude'] as double;
//           final newBusPosition = LatLng(newLat, newLng);
//           log(
//             "Received new bus location: $newBusPosition",
//             name: "Real-time Update",
//           );

//           // Remove old bus marker and add new one
//           markers.removeWhere(
//             (marker) => marker.markerId.value == "bus_marker",
//           );
//           markers.add(
//             Marker(
//               markerId: const MarkerId("bus_marker"),
//               position: newBusPosition,
//               icon: busIcon,
//             ),
//           );

//           // Animate the camera to follow the bus
//           if (googleMapController.isCompleted) {
//             GoogleMapController controller = await googleMapController.future;
//             await controller.animateCamera(
//               CameraUpdate.newLatLng(newBusPosition),
//             );
//           }
//           emit(SuccessState());
//         }
//       },
//       onError: (e) {
//         log("Stream error: $e", name: "Supabase Stream Error");
//         emit(ErrorState(message: "Real-time location stream failed."));
//       },
//     );
//   }

//   // Function to get the real-time stream for the bus location
//   Stream<List<Map<String, dynamic>>> getParentBusLocation() {
//     try {
//       log("starting getParentBusLocation stream");
//       return _supabase
//           .from('bus_locations')
//           .stream(primaryKey: ['id'])
//           .eq('bus_id',bus!.id!)
//           .order('timestamp', ascending: false)
//           .limit(1);
//     } catch (e) {
//       log("error in getting parent bus location $e");
//       rethrow;
//     }
//   }

//   Future<bool> _checkAndRequestLocationPermissions(
//     Emitter<TrackBusState> emit,
//   ) async {
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;

//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         emit(
//           ErrorState(
//             message: "Location services are disabled. Please enable them.",
//           ),
//         );
//         return false;
//       }
//     }

//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         emit(
//           ErrorState(
//             message:
//                 "Location permissions are denied. The app cannot function without them.",
//           ),
//         );
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

//     markers.add(
//       Marker(
//         markerId: const MarkerId("destination"),
//         position: destinationLocation,
//         icon: houseIcon,
//       ),
//     );
//   }

//   Future<void> getPolyLine(Emitter<TrackBusState> emit) async {
//     try {
//       // For now, we use a fixed source location. For a real app,
//       // the source should be the bus's starting point from the database.
//       PolylineResult polylineResult = await polylinePoints
//           .getRouteBetweenCoordinates(
//             request: PolylineRequest(
//               origin: PointLatLng(
//                 // This should be the bus's starting location for the trip
//                 // For demonstration, we use a fixed location
//                 24.531841587266925,
//                 46.66573800258332,
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
//         log(
//           "No polyline points found. Check API key and coordinates.",
//           name: "getPolyLine",
//         );
//       }
//     } catch (e, stacktrace) {
//       log(
//         "Error fetching polyline: $e",
//         name: "getPolyLine",
//         stackTrace: stacktrace,
//       );
//       emit(
//         ErrorState(
//           message:
//               "Failed to get route. Please check your API key and network connection.",
//         ),
//       );
//     }
//   }

//   Future<void> getCurrentLocation(Emitter<TrackBusState> emit) async {
//     try {
//       locationData = await location.getLocation();

//       // Update the user's current location marker
//       markers.add(
//         Marker(
//           markerId: const MarkerId("user_current_location"),
//           position: LatLng(locationData!.latitude!, locationData!.longitude!),
//           icon: BitmapDescriptor.defaultMarker,
//         ),
//       );

//       locationSubscription?.cancel();
//       locationSubscription = location.onLocationChanged.listen((
//         LocationData newLocation,
//       ) async {
//         locationData = newLocation;
//         markers.removeWhere((m) => m.markerId.value == "user_current_location");
//         markers.add(
//           Marker(
//             markerId: const MarkerId("user_current_location"),
//             position: LatLng(newLocation.latitude!, newLocation.longitude!),
//             icon: BitmapDescriptor.defaultMarker,
//           ),
//         );
//         emit(SuccessState());
//       });
//     } catch (e, stacktrace) {
//       log(
//         "Error getting current location: $e",
//         name: "getCurrentLocation",
//         stackTrace: stacktrace,
//       );
//       emit(
//         ErrorState(
//           message:
//               "Failed to get your current location. Please ensure location services are enabled.",
//         ),
//       );
//     }
//   }

//   @override
//   Future<void> close() {
//     _busLocationSubscription?.cancel();
//     locationSubscription?.cancel();
//     return super.close();
//   }
// }
// File: lib/features/parents/track_bus/bloc/track_bus_bloc.dart
// هذا الكود يستخدم Supabase لجلب بيانات الرحلة وتتبع موقع الحافلة بشكل مباشر.

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/data_layer/auth_layer.dart';
import 'package:my_little_route/data_layer/auth_service_layer.dart';
import 'package:my_little_route/models/buses/buses_model.dart';
import 'package:my_little_route/models/student/students_models.dart';
import 'package:my_little_route/models/user/user_model.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math' show cos, sqrt, asin;


part 'track_bus_event.dart';
part 'track_bus_state.dart';

class TrackBusBloc extends Bloc<TrackBusEvent, TrackBusState> {
  //Coordinates for the destination location (the student's home)
  LatLng destinationLocation = LatLng(24.54140337386369, 46.66509543278269);
  // Example school location - you should get this from your data source
  LatLng schoolLocation = LatLng(24.580216, 46.671569); 
  
  // Marker icons and set
  BitmapDescriptor busIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor houseIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor schoolIcon = BitmapDescriptor.defaultMarker;
  Set<Marker> markers = {};
  Completer<GoogleMapController> googleMapController = Completer();
  
  // Supabase client
  final _supabase = Supabase.instance.client;

  // The ID of the current trip and the bus
  String? _currentTripId;
  String? _busId;
  
  // Stream subscription for real-time bus location updates
  StreamSubscription<List<Map<String, dynamic>>>? _busLocationSubscription;

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

  // The student ID to track
  String? _studentId;

  // New variables for conditional route drawing
  LatLng? _previousStopLocation;
  
  // A flag to ensure the notification is sent only once per trip
  bool _notificationSent = false;


  TrackBusBloc() : super(TrackBusInitial()) {
    on<LoadInitialDataEvent>(onLoadInitialDataMethod);
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

      // Step 2: Get student ID
      final appGetit = GetIt.I.get<AppDataLayer>();
      final children = await appGetit.getParentChildren(parentId: appGetit.user!.id!);
      if (children == null || children.isEmpty) {
        emit(ErrorState(message: "No children found for this parent."));
        return;
      }
      _studentId = children[0].id;
      // تأكد من أن قيم خطوط الطول والعرض ليست فارغة قبل استخدامها
      if (children[0].latitude == null || children[0].longitude == null) {
        emit(ErrorState(message: "Student's location data is missing."));
        return;
      }
      destinationLocation = LatLng(children[0].latitude!, children[0].longitude!);

      // Step 3: Get today's trip ID, bus ID, and previous stop location based on the student
      await _fetchTodayTrip(emit, _studentId!);

      // Step 4: Get icons and create static markers
      await _getIconsAndMarkers();
      
      // Step 5: Start real-time location listening
      _startBusLocationStream(emit);
      
      // Step 6: Get user's current location and add marker
      await getCurrentLocation(emit);

      emit(SuccessState());
    } catch (e, stacktrace) {
      log("An error occurred: $e", name: "TrackBusBloc", stackTrace: stacktrace);
      emit(ErrorState(message: e.toString()));
    }
  }

  // Gets the current day's trip and its bus ID from the database, linked to a specific student
  Future<void> _fetchTodayTrip(
    Emitter<TrackBusState> emit,
    String studentId,
  ) async {
    try {
      final now = DateTime.now();
      final tripType = now.hour < 12 ? 'pickup' : 'dropoff'; // Determine if it's morning or afternoon

      // First, find the active trip for today that matches the trip type.
      final activeTrip = await _supabase
          .from('trips')
          .select('id, bus_id')
          .eq('trip_type', tripType)
          .eq('is_completed', false)
          .gte('scheduled_time', DateTime(now.year, now.month, now.day))
          .lt('scheduled_time', DateTime(now.year, now.month, now.day + 1))
          .limit(1)
          .single(); // Use single() here as we only expect one active trip

      if (activeTrip == null) {
          emit(ErrorState(message: "Failed to find today's active trip."));
          return;
      }

      _currentTripId = activeTrip['id'];
      _busId = activeTrip['bus_id'];

      // Now, fetch all students for this trip to find the previous stop.
      // The list is sorted by 'stop_order', which starts from 1.
      final studentsOnTrip = await _supabase
          .from('students')
          .select('id, stop_order, latitude, longitude')
          .eq('trip_id', _currentTripId!)
          .order('stop_order');

      if (studentsOnTrip == null || studentsOnTrip.isEmpty) {
          emit(ErrorState(message: "No students found for the active trip."));
          return;
      }

      final studentsList = studentsOnTrip as List<dynamic>;

      // Find the current student's index in the 0-based list
      final studentIndex = studentsList.indexWhere((s) => s['id'] == studentId);
      
      if (studentIndex == -1) {
          emit(ErrorState(message: "Your student is not on the active trip list."));
          return;
      }

      // Check if the student is the first one in the list (stop_order = 1, index = 0)
      if (studentIndex == 0) {
        log("Current student is the first stop, drawing will start from bus location.", name: "Route Logic");
        _previousStopLocation = null; // No previous stop, so the route starts from the bus
      } else {
        // For all other students, the previous student is at index 'studentIndex - 1'
        final previousStudent = studentsList[studentIndex - 1];
        _previousStopLocation = LatLng(previousStudent['latitude'] as double, previousStudent['longitude'] as double);
        log("Previous stop location set to: $_previousStopLocation", name: "Previous Stop");
      }

      log("Found trip ID: $_currentTripId with bus ID: $_busId", name: "Trip Fetch");
    } on PostgrestException catch (e) {
      log("PostgrestError fetching trip: $e", name: "SupabaseError");
      emit(ErrorState(message: "Failed to find today's active trip. Please check trip data in the database."));
    } catch (e) {
      log("General error fetching trip: $e", name: "Trip Fetch Error");
      emit(ErrorState(message: "An unexpected error occurred while fetching trip data."));
    }
  }

  // Starts the real-time listener for the bus's location
  void _startBusLocationStream(Emitter<TrackBusState> emit) {
    if (_busId == null) {
      log("Bus ID is null, cannot start stream.", name: "Stream Error");
      emit(ErrorState(message: "Failed to find bus for today's trip."));
      return;
    }

    _busLocationSubscription?.cancel();
    
    _busLocationSubscription = getParentBusLocation().listen((data) async {
      if (data.isNotEmpty) {
        final latestLocation = data.first;
        final newLat = latestLocation['latitude'] as double;
        final newLng = latestLocation['longitude'] as double;
        final newBusPosition = LatLng(newLat, newLng);
        log("Received new bus location: $newBusPosition", name: "Real-time Update");

        // Remove old bus marker and add new one
        markers.removeWhere((marker) => marker.markerId.value == "bus_marker");
        markers.add(
            Marker(
                markerId: const MarkerId("bus_marker"),
                position: newBusPosition,
                icon: busIcon,
            ),
        );
        
        // Clear all old polylines
        polylines.clear();

        // Check if the bus has reached the previous stop to start drawing the bus route
        if (_previousStopLocation == null) {
          // If first stop, draw bus route from current bus location to student's home
          await _getPolyline(
            emit,
            start: newBusPosition,
            end: destinationLocation,
            color: StyleColor.blue,
            id: "bus_route"
          );
        } else {
          final distanceToPreviousStop = _calculateDistance(newBusPosition, _previousStopLocation!);
          // If bus is close to the previous stop, start drawing the bus route
          if (distanceToPreviousStop <= 0.1) {
              await _getPolyline(
                emit,
                start: newBusPosition,
                end: destinationLocation,
                color: StyleColor.blue,
                id: "bus_route"
              );
          }
        }

        // Always draw the route from student's home to school
        await _getPolyline(
            emit,
            start: destinationLocation,
            end: schoolLocation,
            color: StyleColor.green,
            id: "student_route"
        );
        
        // Check and send notification if the bus is close
        _checkForNotification(newBusPosition);

        // Animate the camera to follow the bus
        if (googleMapController.isCompleted) {
            GoogleMapController controller = await googleMapController.future;
            await controller.animateCamera(
                CameraUpdate.newLatLng(newBusPosition),
            );
        }
        emit(SuccessState());
      }
    }, onError: (e) {
        log("Stream error: $e", name: "Supabase Stream Error");
        emit(ErrorState(message: "Real-time location stream failed."));
    });
  }

  // Function to calculate distance between two lat/lng points
  double _calculateDistance(LatLng start, LatLng end) {
    const double p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 - cos((end.latitude - start.latitude) * p) / 2 +
              cos(start.latitude * p) * cos(end.latitude * p) *
              (1 - cos((end.longitude - start.longitude) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  // Function to check and send notification
  void _checkForNotification(LatLng busLocation) {
    if (_notificationSent) {
      return; // Avoid sending multiple notifications
    }

    final distanceInKm = _calculateDistance(busLocation, destinationLocation);
    // You can adjust the distance threshold as needed, e.g., 0.5 km (500 meters)
    if (distanceInKm <= 0.5) {
      log("Bus is near destination! Sending notification...", name: "Notification Logic");
      
      // TODO: Replace this log with your actual notification service call
      // Example: YourNotificationService.sendNotification("Bus is arriving soon!");
      
      _notificationSent = true;
    }
  }

  // Function to get the real-time stream for the bus location
  Stream<List<Map<String, dynamic>>> getParentBusLocation() {
    try {
      log("starting getParentBusLocation stream");
      return _supabase
          .from('bus_locations')
          .stream(primaryKey: ['id'])
          .eq('bus_id', _busId!)
          .order('timestamp', ascending: false)
          .limit(1);
    } catch (e) {
      log("error in getting parent bus location $e");
      rethrow;
    }
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
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
   

    busIcon = iconResult[0];
    houseIcon = iconResult[1];
    schoolIcon = iconResult[2];

    markers.add(
      Marker(
        markerId: const MarkerId("destination"),
        position: destinationLocation,
        icon: houseIcon,
      ),
    );

    // Add marker for the school
    markers.add(
      Marker(
        markerId: const MarkerId("school"),
        position: schoolLocation,
        icon: schoolIcon,
        infoWindow: InfoWindow(title: "المدرسة"),
      ),
    );
  }

  // A new helper function to get polyline based on dynamic start and end points
  Future<void> _getPolyline(
      Emitter<TrackBusState> emit, {
      required LatLng start,
      required LatLng end,
      required Color color,
      required String id,
  }) async {
    try {
      PolylineResult polylineResult = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(start.latitude, start.longitude),
          destination: PointLatLng(end.latitude, end.longitude),
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
            polylineId: PolylineId(id),
            points: polyPoints,
            color: color,
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
          markerId: const MarkerId("user_current_location"),
          position: LatLng(locationData!.latitude!, locationData!.longitude!),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      
      locationSubscription?.cancel();
      locationSubscription = location.onLocationChanged.listen((LocationData newLocation) async {
        locationData = newLocation;
        markers.removeWhere((m) => m.markerId.value == "user_current_location");
        markers.add(
          Marker(
            markerId: const MarkerId("user_current_location"),
            position: LatLng(newLocation.latitude!, newLocation.longitude!),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
        emit(SuccessState());
      });
    } catch (e, stacktrace) {
      log("Error getting current location: $e", name: "getCurrentLocation", stackTrace: stacktrace);
      emit(ErrorState(message: "Failed to get your current location. Please ensure location services are enabled."));
    }
  }

  @override
  Future<void> close() {
    _busLocationSubscription?.cancel();
    locationSubscription?.cancel();
    return super.close();
  }
}

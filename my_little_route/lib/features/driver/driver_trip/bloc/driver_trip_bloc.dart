// import 'dart:async';
// import 'dart:developer';
// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:meta/meta.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:ui' as ui;
// import 'package:flutter/services.dart';
// import 'package:my_little_route/data_layer/app_data_layer.dart';
// import 'package:my_little_route/data_layer/auth_service_layer.dart';
// import 'package:my_little_route/models/buses/buses_model.dart';
// import 'package:my_little_route/models/student/students_models.dart';
// import 'package:my_little_route/models/trip/trip_model.dart';
// import 'package:my_little_route/models/trip_stop/trip_stop_model.dart';
// import 'package:my_little_route/models/trip_students/trip_students_model.dart';
// import 'package:my_little_route/style/style_color.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// part 'driver_trip_event.dart';
// part 'driver_trip_state.dart';

// class DriverTripBloc extends Bloc<DriverTripEvent, DriverTripState> {
//   final appGetit = GetIt.I.get<AppDataLayer>();
//   final authServiceLGetit = GetIt.I.get<AuthServiceLayer>();
//   final sharedPrefs = GetIt.I.get<SharedPreferences>();
//   List<StudentsModel>? students;
//   BusesModel? bus;
//   TripModel? trip;
//   List<TripStudentsModel>? studentsTrip;
//   List<TripStopModel>? tripStops;
//   StreamSubscription<Position>? _positionStreamSubscription;
//   //to draw by google map
//   Set<Polyline> mapPolylines = {};
//   Set<Marker> mapMarkers = {};
//   GoogleMapController? mapController;
//   BitmapDescriptor? busIcon;
//   BitmapDescriptor? maleChildMarkerIcon;
//   BitmapDescriptor? femaleChildMarkerIcon;
//   BitmapDescriptor? pickedUpChildMarkerIcon;

//   DriverTripBloc() : super(DriverTripInitial()) {
//     on<GetDriverAndStudentsEvent>(getDriverAndStudentsMethod);
//     on<CreateTripEvent>(createTripeMethod);
//     on<UpdateStudentStatusEvent>(updateStudentStatusMethod);
//     on<EndTripEvent>(endTripMethod);
//     on<GetTripEvent>(getTripMethod);
//     on<UpdateMapDataEvent>(updateMapData);
//     on<CreateReturnTripEvent>(createReturnTripMethod);
//     _loadCustomMarkers();
//   }
//   listen() {
//     log("start listen listenlistenlistenlistenlisten");

//       // حفظ الـ subscription في المتغير الخاص به
//       _positionStreamSubscription = Geolocator.getPositionStream().listen((
//         value,
//       ) {
//         mapController?.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: LatLng(value.latitude, value.longitude),
//               zoom: 15,
//             ),
//           ),
//         );
//       });
//        getLocation() async {
//     final LocationSettings locationSettings = LocationSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 100,
//     );

//     Position position = await Geolocator.getCurrentPosition(
//       locationSettings: locationSettings,
//     );
//    var  currentLocation = LatLng(position.latitude, position.longitude);

//     log("start listen listenlistenlistenlistenlisten");
//   }

//   Future<BitmapDescriptor> _getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(
//       data.buffer.asUint8List(),
//       targetWidth: width,
//     );
//     ui.FrameInfo fi = await codec.getNextFrame();
//     ByteData? byteData = await fi.image.toByteData(
//       format: ui.ImageByteFormat.png,
//     );
//     return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
//   }

//   Future<void> _loadCustomMarkers() async {
//     try {
//       busIcon = await _getBytesFromAsset('assets/image/bus-icon.png', 100);
//       maleChildMarkerIcon = await _getBytesFromAsset(
//         'assets/image/marker-child.png',
//         100,
//       );
//       femaleChildMarkerIcon = await _getBytesFromAsset(
//         'assets/image/marker-girl.png',
//         100,
//       );

//       pickedUpChildMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueGreen,
//       );
//       log("Custom markers loaded successfully.");
//     } catch (e) {
//       log("Error loading custom markers: $e");
//     }
//   }

//   FutureOr<void> getDriverAndStudentsMethod(
//     GetDriverAndStudentsEvent event,
//     Emitter<DriverTripState> emit,
//   ) async {
//     try {
//       sharedPrefs.clear();
//       emit(LoadingState());
//       if (appGetit.user == null) {
//         await appGetit.getUser(id: authServiceLGetit.currentUser!.id);
//       }

//       students = await appGetit.getStudentForDriver(
//         id: authServiceLGetit.currentUser!.id,
//       );
//       for (var element in students!) {
//         log(element.toString());
//       }
//       final driverLat = appGetit.user?.latitude;
//       final driverLng = appGetit.user?.longitude;

//       if (driverLat != null && driverLng != null) {
//         students!.sort((a, b) {
//           final distA = calculateDistance(
//             driverLat,
//             driverLng,
//             a.latitude!,
//             a.longitude!,
//           );
//           final distB = calculateDistance(
//             driverLat,
//             driverLng,
//             b.latitude!,
//             b.longitude!,
//           );
//           return distA.compareTo(distB);
//         });
//       }

//       bus = await appGetit.getBusForDriver(
//         id: authServiceLGetit.currentUser!.id,
//       );
//       log(bus.toString());
//       if (bus != null && appGetit.user != null) {
//         log(bus.toString());
//         listen();
//       }

//       emit(SuccessState());
//     } catch (e) {
//       emit(ErrorState(messge: e.toString()));
//     }
//   }

//   FutureOr<void> getTripMethod(
//     GetTripEvent event,
//     Emitter<DriverTripState> emit,
//   ) async {
//     try {
//       if (sharedPrefs.getString("trip_id") != null) {
//         log("start bloc getTripMethod");
//         trip = await appGetit.getTrip(
//           tripId: sharedPrefs.getString("trip_id").toString(),
//         );

//         tripStops = await appGetit.getTripStops(
//           tripId: sharedPrefs.getString("trip_id").toString(),
//         );
//         studentsTrip = await appGetit.getStudentsTrip(
//           tripId: sharedPrefs.getString("trip_id").toString(),
//         );
//         emit(SucssesGetTripState());
//       } else {
//         add(CreateTripEvent());
//       }
//     } on Exception catch (e) {
//       log("sqqqq");
//       emit(ErrorGetTripState(messge: e.toString()));
//       log(e.toString());
//     }
//   }

//   FutureOr<void> createTripeMethod(
//     CreateTripEvent event,
//     Emitter<DriverTripState> emit,
//   ) async {
//     try {
//       emit(LoadingState());

//       trip = await appGetit.createTrip(
//         newTrip: TripModel(
//           busId: bus!.id!,
//           driverId: appGetit.user!.id!,
//           tripType: 'pickup',
//           scheduledTime: DateTime.now(),
//           status: 'started',
//         ),
//       );

//       sharedPrefs.setString("trip_id", trip!.id!);
//       final tripStopsList = students!.asMap().entries.map((entry) {
//         final index = entry.key;
//         final student = entry.value;
//         final stope = TripStopModel(
//           tripId: trip!.id!,
//           studentId: student.id!,
//           stopOrder: index + 1,
//           latitude: student.latitude!,
//           longitude: student.longitude!,
//           stopType: 'pickup_point',
//           addressDescription: null,
//         ).toMap();
//         stope.remove('id');
//         return stope;
//       }).toList();
//       for (var element in tripStopsList) {
//         log(element.toString());
//       }
//       await appGetit.sendTripStops(tripStopsList: tripStopsList);

//       final tripStudentsList = students!.map((student) {
//         final studentTrip = TripStudentsModel(
//           tripId: trip!.id!,
//           studentId: student.id!,
//           pickupStatus: false,
//           dropoffStatus: false,
//           pickupTime: null,
//           dropoffTime: null,
//         ).toMap();
//         studentTrip.remove('id');
//         return studentTrip;
//       }).toList();

//       studentsTrip = await appGetit.sendStudentsTrip(
//         tripStudentsList: tripStudentsList,
//       );

//       emit(SuccessAddNewTripState());

//       add(UpdateMapDataEvent());
//     } catch (e) {
//       log(e.toString());
//       emit(ErrorState(messge: " ${e.toString()}"));
//     }
//   }

//   FutureOr<void> updateStudentStatusMethod(
//     UpdateStudentStatusEvent event,
//     Emitter<DriverTripState> emit,
//   ) async {
//     try {
//       log("start bloc updateStudentStatusMethod");
//       TripStudentsModel? updatedStudentTrip;

//       if (event.tripType == 'pickup') {
//         updatedStudentTrip = await appGetit.updateStudentPickupStatus(
//           studentTrip: TripStudentsModel(
//             tripId: event.tripStudent.tripId,
//             studentId: event.student.id!,
//             pickupStatus: event.newStatus,
//             pickupTime: event.newStatus ? DateTime.now() : null,
//             dropoffStatus: false,
//           ),
//         );
//       } else if (event.tripType == 'dropoff') {
//         updatedStudentTrip = await appGetit.updateStudentDropOffStatus(
//           studentTrip: TripStudentsModel(
//             tripId: event.tripStudent.tripId,
//             studentId: event.student.id!,
//             dropoffStatus: event.newStatus,
//             dropoffTime: event.newStatus ? DateTime.now() : null,
//             pickupStatus: event.tripStudent.pickupStatus,
//           ),
//         );
//       } else {
//         log("Error: Unknown trip type: ${event.tripType}");
//         emit(ErrorState(messge: "Unknown trip type for status update."));
//         return;
//       }

//       if (updatedStudentTrip != null) {
//         final index = studentsTrip!.indexWhere(
//           (tripStudent) =>
//               tripStudent.tripId == event.tripStudent.tripId &&
//               tripStudent.studentId == event.student.id,
//         );

//         if (index != -1) {
//           studentsTrip![index] = updatedStudentTrip;
//         }
//       }
//       log("--------------------------------");
//       for (var element in students!) {
//         log("--------------------------------");
//         log(element.toString());
//       }
//       emit(SuccessState());
//     } catch (e) {
//       emit(ErrorState(messge: e.toString()));
//     }
//   }

//   FutureOr<void> endTripMethod(
//     EndTripEvent event,
//     Emitter<DriverTripState> emit,
//   ) {}

//   //fucntions

//   double calculateDistance(
//     double startLat,
//     double startLng,
//     double endLat,
//     double endLng,
//   ) {
//     return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
//   }

//   FutureOr<void> updateMapData(
//     UpdateMapDataEvent event,
//     Emitter<DriverTripState> emit,
//   ) async {
//     mapMarkers.clear();
//     mapPolylines.clear();

//     if (appGetit.user != null &&
//         appGetit.user!.latitude != null &&
//         appGetit.user!.longitude != null) {
//       mapMarkers.add(
//         Marker(
//           markerId: MarkerId('driver_location'), // ID مميز لماركر السائق
//           position: LatLng(appGetit.user!.latitude!, appGetit.user!.longitude!),
//           infoWindow: InfoWindow(title: "Driver Location"),
//           // هنا التعديل: استخدم busIcon بدلاً من defaultMarkerWithHue
//           icon:
//               busIcon ??
//               BitmapDescriptor.defaultMarkerWithHue(
//                 BitmapDescriptor.hueBlue,
//               ), //
//         ),
//       );

//       List<LatLng> polylinePoints = [];
//       // نقطة بداية المسار هي موقع السائق
//       polylinePoints.add(
//         LatLng(appGetit.user!.latitude!, appGetit.user!.longitude!),
//       );

//       // إضافة ماركرز الطلاب ونقاطهم للمسار
//       if (students != null) {
//         for (var student in students!) {
//           if (student.latitude != null && student.longitude != null) {
//             // البحث عن حالة الطالب في الرحلة الحالية
//             final studentTripStatus = studentsTrip?.firstWhere(
//               (ts) => ts.studentId == student.id && ts.tripId == trip?.id,
//               orElse: () => TripStudentsModel(
//                 // أضف orElse لتجنب الخطأ لو الطالب مش موجود في studentsTrip
//                 tripId: trip?.id ?? '', // قيمة افتراضية مناسبة
//                 studentId: student.id ?? '', // قيمة افتراضية مناسبة
//                 pickupStatus: false,
//                 dropoffStatus: false,
//                 pickupTime: null,
//                 dropoffTime: null,
//               ),
//             );

//             BitmapDescriptor studentIcon;
//             if (studentTripStatus?.pickupStatus == true) {
//               // إذا تم الالتقاط، استخدم أيقونة مخصصة (إذا وجدت) أو أيقونة خضراء
//               studentIcon =
//                   pickedUpChildMarkerIcon ??
//                   BitmapDescriptor.defaultMarkerWithHue(
//                     BitmapDescriptor.hueGreen,
//                   );
//             } else {
//               // إذا لم يتم الالتقاط، استخدم أيقونة حسب الجنس
//               if (student.gender == 'Male') {
//                 //
//                 studentIcon =
//                     maleChildMarkerIcon ??
//                     BitmapDescriptor.defaultMarkerWithHue(
//                       BitmapDescriptor.hueOrange,
//                     );
//               } else if (student.gender == 'Female') {
//                 //
//                 studentIcon =
//                     femaleChildMarkerIcon ??
//                     BitmapDescriptor.defaultMarkerWithHue(
//                       BitmapDescriptor.hueOrange,
//                     );
//               } else {
//                 studentIcon = BitmapDescriptor.defaultMarkerWithHue(
//                   BitmapDescriptor.hueOrange,
//                 ); // أيقونة افتراضية
//               }
//             }

//             mapMarkers.add(
//               Marker(
//                 markerId: MarkerId(student.id!),
//                 position: LatLng(student.latitude!, student.longitude!),
//                 infoWindow: InfoWindow(title: student.name),
//                 icon: studentIcon,
//               ),
//             );
//             polylinePoints.add(
//               LatLng(student.latitude!, student.longitude!),
//             ); // إضافة نقطة الطالب للمسار
//           }
//         }
//       }

//       // إضافة المسار (Polyline)
//       if (polylinePoints.length > 1) {
//         // تأكد من وجود نقطتين على الأقل لرسم خط
//         mapPolylines.add(
//           Polyline(
//             polylineId: PolylineId('driver_route'),
//             points: polylinePoints,
//             color: StyleColor.buttonBlue, // لون المسار الذي طلبته
//             width: 5,
//           ),
//         );
//       }
//     } else {
//       // رسالة تسجيل (log) في حال عدم توفر موقع السائق
//       log("Driver's location is not available to draw the map.");
//       // يمكنك هنا أيضًا إرسال حالة خطأ إلى واجهة المستخدم إذا أردت التعامل مع هذه الحالة بشكل مرئي
//       // emit(ErrorState(messge: "Driver location not available to display map."));
//     }

//     // إرسال حالة MapDataReadyState لإعلام واجهة المستخدم بأن بيانات الخريطة جاهزة
//     emit(MapDataReadyState());
//   }

//   FutureOr<void> createReturnTripMethod(
//     CreateReturnTripEvent event,
//     Emitter<DriverTripState> emit,
//   ) async {
//     if (sharedPrefs.getString('"trip_id"') != null) {
//       add(GetTripEvent());
//     } else {
//       try {
//         trip = await appGetit.createTrip(
//           newTrip: TripModel(
//             busId: bus!.id!,
//             driverId: appGetit.user!.id!,
//             tripType: 'dropoff',
//             scheduledTime: DateTime.now(),
//             status: 'started',
//           ),
//         );

//         final tripStopsList = students!.asMap().entries.map((entry) {
//           final index = entry.key;
//           final student = entry.value;
//           final stope = TripStopModel(
//             tripId: trip!.id!,
//             studentId: student.id!,
//             stopOrder: index + 1,
//             latitude: student.latitude!,
//             longitude: student.longitude!,
//             stopType: 'dropoff_point',
//             addressDescription: null,
//           ).toMap();
//           stope.remove('id');
//           return stope;
//         }).toList();
//         for (var element in tripStopsList) {
//           log(element.toString());
//         }
//         await appGetit.sendTripStops(tripStopsList: tripStopsList);

//         final tripStudentsList = students!.map((student) {
//           final studentTrip = TripStudentsModel(
//             tripId: trip!.id!,
//             studentId: student.id!,
//             pickupStatus: false,
//             dropoffStatus: false,
//             pickupTime: null,
//             dropoffTime: null,
//           ).toMap();
//           studentTrip.remove('id');
//           return studentTrip;
//         }).toList();

//         studentsTrip = await appGetit.sendStudentsTrip(
//           tripStudentsList: tripStudentsList,
//         );

//         emit(SuccessAddNewTripState());
//         await sharedPrefs.clear();
//         add(UpdateMapDataEvent());
//       } catch (e) {
//         log(e.toString());
//         emit(ErrorState(messge: " ${e.toString()}"));
//       }
//     }
//   }
// }
// }
import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/data_layer/auth_service_layer.dart';
import 'package:my_little_route/models/buses/buses_model.dart';
import 'package:my_little_route/models/student/students_models.dart';
import 'package:my_little_route/models/trip/trip_model.dart';
import 'package:my_little_route/models/trip_stop/trip_stop_model.dart';
import 'package:my_little_route/models/trip_students/trip_students_model.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'driver_trip_event.dart';
part 'driver_trip_state.dart';

class DriverTripBloc extends Bloc<DriverTripEvent, DriverTripState> {
  final appGetit = GetIt.I.get<AppDataLayer>();
  final authServiceLGetit = GetIt.I.get<AuthServiceLayer>();
  final sharedPrefs = GetIt.I.get<SharedPreferences>();
  List<StudentsModel>? students;
  BusesModel? bus;
  TripModel? trip;
  List<TripStudentsModel>? studentsTrip;
  List<TripStopModel>? tripStops;
  StreamSubscription<Position>? _positionStreamSubscription;
Timer? _timer;

  Set<Polyline> mapPolylines = {};
  Set<Marker> mapMarkers = {};
  GoogleMapController? mapController;
  BitmapDescriptor? busIcon;
  BitmapDescriptor? maleChildMarkerIcon;
  BitmapDescriptor? femaleChildMarkerIcon;
  BitmapDescriptor? pickedUpChildMarkerIcon;

  DriverTripBloc() : super(DriverTripInitial()) {
    on<GetDriverAndStudentsEvent>(getDriverAndStudentsMethod);
    on<CreateTripEvent>(createTripeMethod);
    on<UpdateStudentStatusEvent>(updateStudentStatusMethod);
    on<EndTripEvent>(endTripMethod);
    on<GetTripEvent>(getTripMethod);
    on<UpdateMapDataEvent>(updateMapData);
    on<CreateReturnTripEvent>(createReturnTripMethod);
    _loadCustomMarkers();
  }
  
@override
Future<void> close() {
   _positionStreamSubscription?.cancel();
  _timer?.cancel();
   return super.close();
}

  // void startTracking(String busId) {
  //   _timer?.cancel();
  //   _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
  //     try {
  //       final position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high,
  //       );

  //       await appGetit.updateOrInsertDriverLocation(
  //         busId: busId,
  //         latitude: position.latitude,
  //         longitude: position.longitude,
  //       );

  //       log("Updated location: (\${position.latitude}, \${position.longitude}) for bus: \$busId");
  //     } catch (e) {
  //       log("Failed to get location: \$e");
  //     }
  //   });
  // }

  void stopTracking() {
    _timer?.cancel();
    _timer = null;
    log("Stopped tracking location.");
  }


 
  Future<BitmapDescriptor> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? byteData = await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  Future<void> _loadCustomMarkers() async {
    try {
      busIcon = await _getBytesFromAsset('assets/image/bus-icon.png', 100);
      maleChildMarkerIcon = await _getBytesFromAsset(
        'assets/image/marker-child.png',
        100,
      );
      femaleChildMarkerIcon = await _getBytesFromAsset(
        'assets/image/marker-girl.png',
        100,
      );

      pickedUpChildMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      );
      log("Custom markers loaded successfully.");
    } catch (e) {
      log("Error loading custom markers: $e");
    }
  } 


  FutureOr<void> getDriverAndStudentsMethod(
  GetDriverAndStudentsEvent event,
  Emitter<DriverTripState> emit,
) async {
  try {
    emit(LoadingState());
    final permission = await Geolocator.checkPermission();

if (permission == LocationPermission.denied) {
  final newPermission = await Geolocator.requestPermission();
  if (newPermission == LocationPermission.denied || newPermission == LocationPermission.deniedForever) {
    emit(ErrorState(messge: "تم رفض إذن الموقع، لا يمكن تتبع الموقع."));
    return;
  }
} else if (permission == LocationPermission.deniedForever) {
  emit(ErrorState(messge: "تم رفض إذن الموقع بشكل دائم، افتح إعدادات التطبيق لتفعيله."));
  await Geolocator.openAppSettings();
  return;
}

    if (appGetit.user == null) {
      await appGetit.getUser(id: authServiceLGetit.currentUser!.id);
    }

    students = await appGetit.getStudentForDriver(
      id: authServiceLGetit.currentUser!.id,
    );
    log('Found ${students?.length} students for driver');

    final driverLat = appGetit.user?.latitude;
    final driverLng = appGetit.user?.longitude;

    if (driverLat != null && driverLng != null) {
      students!.sort((a, b) {
        final distA = calculateDistance(
          driverLat,
          driverLng,
          a.latitude!,
          a.longitude!,
        );
        final distB = calculateDistance(
          driverLat,
          driverLng,
          b.latitude!,
          b.longitude!,
        );
        return distA.compareTo(distB);
      });
    }

    bus = await appGetit.getBusForDriver(
      id: authServiceLGetit.currentUser!.id,
    );

    if (bus != null && appGetit.user != null) {
      log("Driver and bus data loaded successfully.");

      // هنا نشترك في تتبع الموقع:
      _positionStreamSubscription?.cancel(); // تأكد إن الاشتراك القديم ملغي
      _positionStreamSubscription = startTracking().listen((position) async {
        log("📍 Position update: ${position.latitude}, ${position.longitude}");

        // مثال: تحديث موقع السائق في الـ backend
        await appGetit.updateOrInsertDriverLocation(
          busId: bus!.id!,
          latitude: position.latitude,
          longitude: position.longitude,
        );

        // // ممكن تحدث بيانات المستخدم محليًا
        // appGetit.user?.latitude = position.latitude;
        // appGetit.user?.longitude = position.longitude;

        add(UpdateMapDataEvent(position: position)); // لتحديث الخريطة بناءً على الموقع الجديد
      });
    }

    emit(SuccessState());
  } catch (e) {
    emit(ErrorState(messge: e.toString()));
  }
}



  FutureOr<void> getTripMethod(
    GetTripEvent event,
    Emitter<DriverTripState> emit,
  ) async {
    try {
      final tripId = sharedPrefs.getString("trip_id");
      if (tripId != null && tripId.isNotEmpty) {
        log("start bloc getTripMethod with tripId: $tripId");
        trip = await appGetit.getTrip(tripId: tripId);

        tripStops = await appGetit.getTripStops(tripId: tripId);
        studentsTrip = await appGetit.getStudentsTrip(tripId: tripId);
        emit(SucssesGetTripState());
      } else {
        log("No trip found in shared preferences, creating a new one.");
        add(CreateTripEvent());
      }
    } on Exception catch (e) {
      log("Error getting trip: $e");
      emit(ErrorGetTripState(messge: e.toString()));
    }
  }

  FutureOr<void> createTripeMethod(
    CreateTripEvent event,
    Emitter<DriverTripState> emit,
  ) async {
    try {
      emit(LoadingState());

      trip = await appGetit.createTrip(
        newTrip: TripModel(
          busId: bus!.id!,
          driverId: appGetit.user!.id!,
          tripType: 'pickup',
          scheduledTime: DateTime.now(),
          status: 'started',
        ),
      );

      sharedPrefs.setString("trip_id", trip!.id!);
      log("New trip created with ID: ${trip!.id!}");

      final tripStopsList = students!.asMap().entries.map((entry) {
        final index = entry.key;
        final student = entry.value;
        final stope = TripStopModel(
          tripId: trip!.id!,
          studentId: student.id!,
          stopOrder: index + 1,
          latitude: student.latitude!,
          longitude: student.longitude!,
          stopType: 'pickup_point',
          addressDescription: null,
        ).toMap();
        stope.remove('id');
        return stope;
      }).toList();
      await appGetit.sendTripStops(tripStopsList: tripStopsList);
      log("Trip stops sent successfully.");

      final tripStudentsList = students!.map((student) {
        final studentTrip = TripStudentsModel(
          tripId: trip!.id!,
          studentId: student.id!,
          pickupStatus: false,
          dropoffStatus: false,
          pickupTime: null,
          dropoffTime: null,
        ).toMap();
        studentTrip.remove('id');
        return studentTrip;
      }).toList();

      studentsTrip = await appGetit.sendStudentsTrip(
        tripStudentsList: tripStudentsList,
      );
      log("Trip students sent successfully.");

      emit(SuccessAddNewTripState());
      add(UpdateMapDataEvent());
    } catch (e) {
      log("Error creating trip: $e");
      emit(ErrorState(messge: " ${e.toString()}"));
    }
  }

  FutureOr<void> updateStudentStatusMethod(
    UpdateStudentStatusEvent event,
    Emitter<DriverTripState> emit,
  ) async {
    try {
      log("start bloc updateStudentStatusMethod");
      TripStudentsModel? updatedStudentTrip;

      final currentTripStudent = studentsTrip!.firstWhere(
        (ts) => ts.studentId == event.student.id,
      );

      if (event.tripType == 'pickup') {
        updatedStudentTrip = await appGetit.updateStudentPickupStatus(
          studentTrip: TripStudentsModel(
            tripId: currentTripStudent.tripId,
            studentId: event.student.id!,
            pickupStatus: event.newStatus,
            pickupTime: event.newStatus ? DateTime.now() : null,
            dropoffStatus: currentTripStudent.dropoffStatus,
          ),
        );
      } else if (event.tripType == 'dropoff') {
        updatedStudentTrip = await appGetit.updateStudentDropOffStatus(
          studentTrip: TripStudentsModel(
            tripId: currentTripStudent.tripId,
            studentId: event.student.id!,
            dropoffStatus: event.newStatus,
            dropoffTime: event.newStatus ? DateTime.now() : null,
            pickupStatus: currentTripStudent.pickupStatus,
          ),
        );
      } else {
        log("Error: Unknown trip type: ${event.tripType}");
        emit(ErrorState(messge: "Unknown trip type for status update."));
        return;
      }

      if (updatedStudentTrip != null) {
        final index = studentsTrip!.indexWhere(
          (tripStudent) =>
              tripStudent.tripId == updatedStudentTrip!.tripId &&
              tripStudent.studentId == updatedStudentTrip.studentId,
        );

        if (index != -1) {
          studentsTrip![index] = updatedStudentTrip;
        }
      }
      log("Student status updated successfully.");
      emit(SuccessState());
    } catch (e) {
      log("Error updating student status: $e");
      emit(ErrorState(messge: e.toString()));
    }
  }

  FutureOr<void> endTripMethod(
    EndTripEvent event,
    Emitter<DriverTripState> emit,
  ) async {
    try {
      emit(LoadingState());
      // if (trip != null) {
      //   await appGetit.updateTripStatus(
      //     tripId: trip!.id!,
      //     newStatus: 'completed',
      //   );
      // }
      await sharedPrefs.remove("trip_id");
      _positionStreamSubscription?.cancel();
      students = null;
      trip = null;
      studentsTrip = null;
      tripStops = null;
      mapMarkers.clear();
      mapPolylines.clear();

      log("Trip ended successfully. Resetting state.");
      emit(TripEndedState());
      add(GetDriverAndStudentsEvent());
    } catch (e) {
      log("Error ending trip: $e");
      emit(ErrorState(messge: "Failed to end trip: ${e.toString()}"));
    }
  }

  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  } FutureOr<void> updateMapData(
  UpdateMapDataEvent event,
  Emitter<DriverTripState> emit,
) async {
  mapMarkers.clear();
  mapPolylines.clear();

  LatLng? driverLatLng;

  if (event.position != null) {
    driverLatLng = LatLng(
      event.position!.latitude,
      event.position!.longitude,
    );
  } else if (appGetit.user != null &&
      appGetit.user!.latitude != null &&
      appGetit.user!.longitude != null) {
    driverLatLng = LatLng(
      appGetit.user!.latitude!,
      appGetit.user!.longitude!,
    );
  }

  if (driverLatLng != null) {
    log('Driver location: (${driverLatLng.latitude}, ${driverLatLng.longitude})');
    mapMarkers.add(
      Marker(
        markerId: MarkerId('driver_location'),
        position: driverLatLng,
        infoWindow: InfoWindow(title: "Driver Location"),
        icon:
            busIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    List<LatLng> polylinePoints = [driverLatLng];

    if (students != null) {
      for (var student in students!) {
        if (student.latitude != null && student.longitude != null && !(student.latitude == 0 && student.longitude == 0)) {
          log('Adding marker for student ${student.name} at (${student.latitude}, ${student.longitude})');

          final studentTripStatus = studentsTrip?.firstWhere(
            (ts) => ts.studentId == student.id && ts.tripId == trip?.id,
            orElse: () => TripStudentsModel(
              tripId: trip?.id ?? '',
              studentId: student.id ?? '',
              pickupStatus: false,
              dropoffStatus: false,
              pickupTime: null,
              dropoffTime: null,
            ),
          );

          BitmapDescriptor studentIcon;
          if (studentTripStatus?.pickupStatus == true) {
            studentIcon = pickedUpChildMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
          } else {
            if (student.gender == 'Male') {
              studentIcon = maleChildMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
            } else if (student.gender == 'Female') {
              studentIcon = femaleChildMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
            } else {
              studentIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
            }
          }

          mapMarkers.add(
            Marker(
              markerId: MarkerId(student.id!),
              position: LatLng(student.latitude!, student.longitude!),
              infoWindow: InfoWindow(title: student.name),
              icon: studentIcon,
            ),
          );

          polylinePoints.add(LatLng(student.latitude!, student.longitude!));
        } else {
          log('Skipping student ${student.name} due to invalid coordinates.');
        }
      }
    }

    if (polylinePoints.length > 1) {
      mapPolylines.add(
        Polyline(
          polylineId: PolylineId('driver_route'),
          points: polylinePoints,
          color: StyleColor.buttonBlue,
          width: 5,
        ),
      );
    }
  } else {
    log("Driver's location is not available to draw the map.");
  }

  emit(MapDataReadyState());
}


  FutureOr<void> createReturnTripMethod(
    CreateReturnTripEvent event,
    Emitter<DriverTripState> emit,
  ) async {
    final tripId = sharedPrefs.getString("trip_id");
    if (tripId != null) {
      add(GetTripEvent());
    } else {
      try {
        emit(LoadingState());

        trip = await appGetit.createTrip(
          newTrip: TripModel(
            busId: bus!.id!,
            driverId: appGetit.user!.id!,
            tripType: 'dropoff',
            scheduledTime: DateTime.now(),
            status: 'started',
          ),
        );

        await sharedPrefs.setString("trip_id", trip!.id!);
        log("Return trip created with ID: ${trip!.id!}");

        final tripStopsList = students!.asMap().entries.map((entry) {
          final index = entry.key;
          final student = entry.value;
          final stope = TripStopModel(
            tripId: trip!.id!,
            studentId: student.id!,
            stopOrder: index + 1,
            latitude: student.latitude!,
            longitude: student.longitude!,
            stopType: 'dropoff_point',
            addressDescription: null,
          ).toMap();
          stope.remove('id');
          return stope;
        }).toList();
        await appGetit.sendTripStops(tripStopsList: tripStopsList);
        log("Return trip stops sent successfully.");

        final tripStudentsList = students!.map((student) {
          final studentTrip = TripStudentsModel(
            tripId: trip!.id!,
            studentId: student.id!,
            pickupStatus: true,
            dropoffStatus: false,
            pickupTime: null,
            dropoffTime: null,
          ).toMap();
          studentTrip.remove('id');
          return studentTrip;
        }).toList();

        studentsTrip = await appGetit.sendStudentsTrip(
          tripStudentsList: tripStudentsList,
        );
        log("Return trip students sent successfully.");

        emit(SucssesCreateReturnTripState());
        add(UpdateMapDataEvent());
      } catch (e) {
        log("Error creating return trip: $e");
        emit(ErrorCreateReturnTripState(messge: " ${e.toString()}"));
      }
    }
  }


  Stream<Position> startTracking() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // التحديث كل ما تحرك 10 متر
      ),
    );
  }
}

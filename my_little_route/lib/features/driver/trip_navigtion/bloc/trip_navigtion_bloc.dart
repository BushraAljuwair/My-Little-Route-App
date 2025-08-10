import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:my_little_route/data_layer/app_data_layer.dart';
import 'package:my_little_route/data_layer/auth_service_layer.dart';
import 'package:my_little_route/models/bus_locations/bus_locations_model.dart';
import 'package:my_little_route/models/buses/buses_model.dart';
import 'package:my_little_route/models/notifications/notifications_model.dart';
import 'package:my_little_route/models/student/students_models.dart';
import 'package:my_little_route/models/trip/trip_model.dart';
import 'package:my_little_route/models/trip_stop/trip_stop_model.dart';
import 'package:my_little_route/models/trip_students/trip_students_model.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

import 'dart:ui' as ui;
import 'package:flutter/services.dart';

part 'trip_navigtion_event.dart';
part 'trip_navigtion_state.dart';

class TripNavigtionBloc extends Bloc<TripNavigtionEvent, TripNavigtionState> {
  final appGetit = GetIt.I.get<AppDataLayer>();
  final authServiceLGetit = GetIt.I.get<AuthServiceLayer>();
  final sharedPrefs = GetIt.I.get<SharedPreferences>();
  Position? driverPostion;

  List<StudentsModel>? students;
  BusesModel? bus;
  TripModel? trip;
  List<TripStudentsModel>? studentsTrip;
  List<TripStopModel>? tripStops;
  StreamSubscription<Position>? _positionStreamSubscription;
  BusLocationsModel? driverLiveLocation;
  Set<Polyline> mapPolylines = {};
  Set<Marker> mapMarkers = {};
  LatLng kindergartenLittleRoute = LatLng(24.5412682270113, 46.6648522263772);
  GoogleMapController? mapController;
  BitmapDescriptor? busIcon;
  BitmapDescriptor? maleChildMarkerIcon;
  BitmapDescriptor? femaleChildMarkerIcon;
  BitmapDescriptor? pickedUpChildMarkerIcon;
  BitmapDescriptor? driverMarkerIcon;
  BitmapDescriptor? schooldMarkerIcon;

  TripNavigtionBloc() : super(TripNavigtionInitial()) {
    _loadCustomMarkers();
    //  sharedPrefs.remove("trip_id");
    // sharedPrefs.remove("return_trip_id");
    // sharedPrefs.clear();
    on<TripNavigtionEvent>((event, emit) {});
    on<GetDriverAndStudentsEvent>(getDriverAndStudentsMethod);
    on<CreatePickUpEvent>(createPickUpMethod);
    on<UpdateMapDataEvent>(updateMapDataMethod);
    on<UpdateStudentStatusEvent>(updateStudentStatusMethod);
    on<EndTripEvent>(endTripMethod);
    // on<NotificationEvent>(notificationMethod);
    on<ReturnEvent>(createReturnMethod);
    on<SendNextStudentNotificationEvent>(sendNextStudentNotificationMethod);
  }

  FutureOr<void> getDriverAndStudentsMethod(
    GetDriverAndStudentsEvent event,
    Emitter<TripNavigtionState> emit,
  ) async {
    emit(LoadingState());
    try {
      driverPostion = await _determinePosition();

      if (appGetit.user == null) {
        await appGetit.getUser(id: authServiceLGetit.currentUser!.id);
      }

      students = await appGetit.getStudentForDriver(
        id: authServiceLGetit.currentUser!.id,
      );
      log('Found ${students?.length} students for driver');

      final driverLat = driverPostion?.latitude;
      final driverLng = driverPostion?.longitude;

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

        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = startTracking().listen((position) async {
          log(
            "📍 Position update: ${position.latitude}, ${position.longitude}",
          );

          final String? driverLocationId = sharedPrefs.getString(
            "driverLiveLocationID",
          );
          log("driverLocationId $driverLocationId");
          if (driverLocationId == null || driverLocationId.isEmpty) {
            driverLiveLocation = await appGetit.updateOrInsertDriverLocation(
              busId: bus!.id!,
              latitude: position.latitude,
              longitude: position.longitude,
            );
            sharedPrefs.setString(
              "driverLiveLocationID",
              (driverLiveLocation!.id!),
            );
          } else {
            driverLiveLocation = await appGetit.updateOrInsertDriverLocation(
              id: driverLocationId,
              busId: bus!.id!,
              latitude: position.latitude,
              longitude: position.longitude,
            );
          }
        });

        emit(SucssesGetTripState());
      }
    } catch (e) {
      emit(ErrorGetInfoState(messge: e.toString()));
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openAppSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        await Geolocator.openAppSettings();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      await Geolocator.openAppSettings();
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  Stream<Position> startTracking() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    );
  }

  FutureOr<void> createPickUpMethod(
    CreatePickUpEvent event,
    Emitter<TripNavigtionState> emit,
  ) async {
    try {
      emit(LoadingPickUpState());
      // sharedPrefs.clear();
      log("-----------------------------------1----------------------;");
      final String? tripId = sharedPrefs.getString("trip_id");
      log(
        tripId ??
            "sdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
      );
      if (tripId != null) {
        log("-----------------------------------2----------------------;");
        trip = await appGetit.getTrip(tripId: tripId);
        tripStops = await appGetit.getTripStops(tripId: tripId);
        studentsTrip = await appGetit.getStudentsTrip(tripId: tripId);
      } else {
        trip = await appGetit.createTrip(
          newTrip: TripModel(
            busId: bus!.id!,
            driverId: appGetit.user!.id!,
            tripType: 'pickup',
            scheduledTime: DateTime.now(),
            status: 'started',
          ),
        );
        log("-----------------------------------1----------------------;");
        log(trip.toString());
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
        tripStops = await appGetit.sendTripStops(tripStopsList: tripStopsList);
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

        await notificationMethod(message: "driverlefthouse");
        log("Calling notification method...");
      }

      emit(SucssesPickUpState());

      // await notificationMethod(message: "driverlefthouse");
      // log("Calling notification method...");
      // if (students != null && students!.isNotEmpty) {
      //   await notificationMethod(message: "driverlefthouse");
      //   log("Notification method finished.");
      // } else {
      //   log("Students list is empty, skipping notification.");
      // }

      add(UpdateMapDataEvent());
    } catch (e) {
      log("Error creating trip: $e");
      emit(ErrorPickUpState(messge: " ${e.toString()}"));
    }
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

      driverMarkerIcon = await _getBytesFromAsset(
        "assets/image/bus-icon.png",
        100,
      );

      schooldMarkerIcon = await _getBytesFromAsset(
        "assets/image/marker-Kindergarten.png",
        100,
      );
      log("Custom markers loaded successfully.");
    } catch (e) {
      log("Error loading custom markers: $e");
    }
  }

  FutureOr<void> updateMapDataMethod(
    UpdateMapDataEvent event,
    Emitter<TripNavigtionState> emit,
  ) {
    // add(SendNextStudentNotificationEvent());
    List<LatLng> polylinePoints = [];
    mapMarkers.clear();
    mapPolylines.clear();

    if (driverLiveLocation != null) {
      mapMarkers.add(
        Marker(
          markerId: MarkerId("driver"),
          infoWindow: InfoWindow(title: "driver "),
          icon: driverMarkerIcon!,
          position: LatLng(
            driverLiveLocation!.latitude,
            driverLiveLocation!.longitude,
          ),
        ),
      );
      polylinePoints.add(
        LatLng(driverLiveLocation!.latitude, driverLiveLocation!.longitude),
      );
    } else {
      log("else mapMarkers ");
      mapMarkers.add(
        Marker(
          markerId: MarkerId("driver"),
          infoWindow: InfoWindow(title: "driver "),
          icon: driverMarkerIcon!,
          position: LatLng(appGetit.user!.latitude!, appGetit.user!.longitude!),
        ),
      );
      polylinePoints.add(
        LatLng(appGetit.user!.latitude!, appGetit.user!.longitude!),
      );
    }
    if (trip!.tripType == "pickup") {
      final studentsNotPickedUp = studentsTrip!
          .where((tripStudent) => tripStudent.pickupStatus == false)
          .toList();
      final tripStopsNotPickedUp = studentsNotPickedUp
          .map(
            (tripStudent) => tripStops!.firstWhere(
              (stop) => stop.studentId == tripStudent.studentId,
            ),
          )
          .toList();

      for (var stpos in tripStopsNotPickedUp) {
        polylinePoints.add(LatLng(stpos.latitude, stpos.longitude!));
      }

      for (var stpos in tripStops!) {
        StudentsModel student = students!.firstWhere(
          (student) => student.id == stpos.studentId,
        );

        var studentTrip = studentsTrip!.firstWhere(
          (tripStudent) => tripStudent.studentId == stpos.studentId,
        );

        bool isPickedUp = studentTrip.pickupStatus;

        mapMarkers.add(
          Marker(
            markerId: MarkerId(stpos.studentId),
            position: LatLng(stpos.latitude, stpos.longitude!),
            icon: isPickedUp
                ? pickedUpChildMarkerIcon!
                : (student.gender == "Female"
                      ? femaleChildMarkerIcon!
                      : maleChildMarkerIcon!),
          ),
        );
      }
    } else {
      final studentsNotDroppedOff = studentsTrip!
          .where((tripStudent) => tripStudent.dropoffStatus == false)
          .toList();
      final tripStopssNotDroppedOff = studentsNotDroppedOff
          .map(
            (tripStudent) => tripStops!.firstWhere(
              (stop) => stop.studentId == tripStudent.studentId,
            ),
          )
          .toList();

      for (var stpos in tripStopssNotDroppedOff) {
        polylinePoints.add(LatLng(stpos.latitude, stpos.longitude!));
      }

      for (var stpos in tripStops!) {
        StudentsModel student = students!.firstWhere(
          (student) => student.id == stpos.studentId,
        );

        var studentTrip = studentsTrip!.firstWhere(
          (tripStudent) => tripStudent.studentId == stpos.studentId,
        );

        bool isPickedUp = studentTrip.pickupStatus;

        mapMarkers.add(
          Marker(
            markerId: MarkerId(stpos.studentId),
            position: LatLng(stpos.latitude, stpos.longitude!),
            icon: isPickedUp
                ? pickedUpChildMarkerIcon!
                : (student.gender == "Female"
                      ? femaleChildMarkerIcon!
                      : maleChildMarkerIcon!),
          ),
        );
      }
    }

    mapMarkers.add(
      Marker(
        markerId: MarkerId("Kindergarten My little Route"),
        infoWindow: InfoWindow(title: "Kindergarten My little Route "),
        icon: schooldMarkerIcon!,
        position: kindergartenLittleRoute,
      ),
    );
    polylinePoints.add(kindergartenLittleRoute);

    if (polylinePoints.length > 1) {
      mapPolylines.add(
        Polyline(
          polylineId: PolylineId("trip route"),
          points: polylinePoints,
          color: StyleColor.blue,
          width: 5,
        ),
      );
    }

    emit(MapDataReadyState());
  }

  FutureOr<void> updateStudentStatusMethod(
    UpdateStudentStatusEvent event,
    Emitter<TripNavigtionState> emit,
  ) async {
    try {
      if (event.tripType == 'pickup') {
        log("pickup");
        var updatedStudentTrip = await appGetit.updateStudentPickupStatus(
          studentTrip: TripStudentsModel(
            tripId: event.tripStudent.tripId,
            studentId: event.student.id!,
            pickupStatus: event.newStatus,
            pickupTime: DateTime.now(),
            dropoffStatus: false,
          ),
        );

        final index = studentsTrip!.indexWhere(
          (tripStudent) =>
              tripStudent.tripId == updatedStudentTrip.tripId &&
              tripStudent.studentId == updatedStudentTrip.studentId,
        );

        if (index != -1) {
          final updatedList = List<TripStudentsModel>.from(studentsTrip!);
          updatedList[index] = updatedStudentTrip;
          studentsTrip = updatedList;
        }
      } else {
        log("drop off");
        var updatedStudentTrip = await appGetit.updateStudentDropOffStatus(
          studentTrip: TripStudentsModel(
            tripId: event.tripStudent.tripId,
            studentId: event.student.id!,
            dropoffStatus: event.newStatus,
            dropoffTime: DateTime.now(),
            pickupStatus: event.tripStudent.pickupStatus,
          ),
        );

        final index = studentsTrip!.indexWhere(
          (tripStudent) =>
              tripStudent.tripId == updatedStudentTrip.tripId &&
              tripStudent.studentId == updatedStudentTrip.studentId,
        );

        if (index != -1) {
          final updatedList = List<TripStudentsModel>.from(studentsTrip!);
          updatedList[index] = updatedStudentTrip;
          studentsTrip = updatedList;
        }
      }

      emit(SucssesState());
      add(UpdateMapDataEvent());
    } catch (e) {
      emit(ErrorUpdateStudentStatusState(messge: e.toString()));
    }
  }

  FutureOr<void> endTripMethod(
    EndTripEvent event,
    Emitter<TripNavigtionState> emit,
  ) async {
    try {
      log("end trip");

      await appGetit.changeTripTypeCompleted(id: trip!.id!);
      if (event.tripType == "pickup") {
        await appGetit.changeDropOffStatus(studentsTrip: studentsTrip!);
        notificationMethod(message: "childrenarrivedkindergarten.");
        sharedPrefs.remove("trip_id");
      } else {
        // notificationMethod(message: "childrenleftkindergarten");
        sharedPrefs.remove("return_trip_id");
      }

      emit(SucssesState());
    } on Exception catch (e) {
      emit(ErrorState(messge: e.toString()));
    }
  }

  // FutureOr<void> notificationMethod(
  //   NotificationEvent event,
  //   Emitter<TripNavigtionState> emit,
  // ) async {
  //   try {
  //     log("--------------------------------------------1");
  //     List<NotificationsModel> parentNotifcation = students!.map((student) {
  //       return NotificationsModel(
  //         message: event.message,
  //         userId: student.parentId,
  //         isRead: false,
  //         createdAt: DateTime.now(),
  //       );
  //     }).toList();

  //     log("--------------------------------------------2");

  //     await appGetit.notification(notifcation: parentNotifcation);
  //     log("--------------------------------------------3");

  //     emit(SucssesState());
  //   } catch (e) {
  //     emit(ErrorState(messge: e.toString()));
  //   }
  // }

  // Future<void> notificationMethod({required String message}) async {
  //   log("start notifcation  bloc");
  //   try {
  //     List<NotificationsModel> parentNotifcation = students!.map((student) {
  //       return NotificationsModel(
  //         message: message,
  //         userId: student.parentId,
  //         isRead: false,
  //         // createdAt: DateTime.now(),
  //          createdAt: DateTime.now(),
  //       );
  //     }).toList();
  //     for (var element in parentNotifcation) {
  //       log("element is ${element.toString()}");
  //     }
  //     await appGetit.notification(notifcation: parentNotifcation);
  //     log("end notifcation  bloc");
  //   return;
  //   } catch (e) {
  //     log("error  notifcation  bloc ${e.toString()}");
  //   }
  // }
  Future<void> notificationMethod({required String message}) async {
    log("start notifcation bloc");
    try {
      // **النقطة المعدلة:** إضافة log قبل عملية الـ map
      log("Mapping students to notifications...");
      if (students == null) {
        log("Error: Students list is null, cannot send notification.");
        return;
      }
      List<NotificationsModel> parentNotifcation = students!.map((student) {
        return NotificationsModel(
          message: message,
          userId: student.parentId,
          isRead: false,
          createdAt: DateTime.now(),
        );
      }).toList();
      log(
        "Finished mapping. Notification list count: ${parentNotifcation.length}",
      );

      for (var element in parentNotifcation) {
        log("Notification element: ${element.toString()}");
      }

      log("Calling appGetit.notification...");
      await appGetit.notification(notifcation: parentNotifcation);
      log("appGetit.notification finished successfully.");
      log("end notifcation bloc");
    } catch (e) {
      log("error notifcation bloc: ${e.toString()}");
    }
  }

  FutureOr<void> createReturnMethod(
    ReturnEvent event,
    Emitter<TripNavigtionState> emit,
  ) async {
    try {
      log("createReturnMethodstart");
      emit(LoadingState());
      final String? tripId = sharedPrefs.getString("return_trip_id");
      log(
        tripId ??
            "sdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
      );
      if (tripId != null) {
        log("tripId != null");

        log("-----------------------------------2----------------------;");
        trip = await appGetit.getTrip(tripId: tripId);
        tripStops = await appGetit.getTripStops(tripId: tripId);
        studentsTrip = await appGetit.getStudentsTrip(tripId: tripId);
      } else {
        log("tripId  null");
        trip = await appGetit.createTrip(
          newTrip: TripModel(
            busId: bus!.id!,
            driverId: appGetit.user!.id!,
            tripType: 'dropoff',
            scheduledTime: DateTime.now(),
            status: 'started',
          ),
        );
        log("-----------------------------------1----------------------;");
        log(trip.toString());
        sharedPrefs.setString("return_trip_id", trip!.id!);
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
            stopType: 'dropoff_point',
            addressDescription: null,
          ).toMap();
          stope.remove('id');
          return stope;
        }).toList();
        tripStops = await appGetit.sendTripStops(tripStopsList: tripStopsList);
        log("Trip stops sent successfully createReturnMethod.");

        final tripStudentsList = students!.map((student) {
          final studentTrip = TripStudentsModel(
            tripId: trip!.id!,
            studentId: student.id!,
            pickupStatus: true,
            dropoffStatus: false,
            pickupTime: DateTime.now(),
            dropoffTime: null,
          ).toMap();
          studentTrip.remove('id');
          return studentTrip;
        }).toList();

        studentsTrip = await appGetit.sendStudentsTrip(
          tripStudentsList: tripStudentsList,
        );
        log("Trip students sent successfully.");
        await notificationMethod(message: "driverlefthouse");
        log("Calling notification method...");
      }
      emit(SucssesState());

      notificationMethod(message: "childrenleftkindergarten");

      // add(NotificationEvent(message: "childrenleftkindergarten"));
      add(UpdateMapDataEvent());
    } catch (e) {
      log("Error creating trip: $e");
      emit(ErrorPickUpState(messge: " ${e.toString()}"));
    }
  }

  FutureOr<void> sendNextStudentNotificationMethod(
    SendNextStudentNotificationEvent event,
    Emitter<TripNavigtionState> emit,
  ) {
    for (var studentStop in tripStops!) {
      final currentStudentTrip = studentsTrip!.firstWhere(
        (student) => studentStop.studentId == student.id,
      );
      final student = students!.firstWhere(
        (student) => student.id == studentStop.id,
      );
      if (currentStudentTrip == null) {
        continue;
      }
      if (studentStop.studentId == currentStudentTrip.studentId &&
          currentStudentTrip.pickupStatus == false &&
          studentStop.tripId == currentStudentTrip.tripId) {
        appGetit.notificationParent(
          notifcation: NotificationsModel(
            userId: student.parentId,
            isRead: false,
            message: "driverwayhome",
            createdAt: DateTime.now(),
          ),
        );
        break;
      }
    }
  }
}

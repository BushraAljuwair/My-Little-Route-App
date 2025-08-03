// ignore_for_file: depend_on_referenced_packages

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

  //to draw by google map
  Set<Polyline> mapPolylines = {};
  Set<Marker> mapMarkers = {};
  GoogleMapController? mapController;
  BitmapDescriptor? busIcon;
  BitmapDescriptor? maleChildMarkerIcon;
  BitmapDescriptor? femaleChildMarkerIcon;
  BitmapDescriptor? pickedUpChildMarkerIcon;
  BitmapDescriptor? school;

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

  FutureOr<void> getDriverAndStudentsMethod(
    GetDriverAndStudentsEvent event,
    Emitter<DriverTripState> emit,
  ) async {
    try {
      // sharedPrefs.clear();
      emit(LoadingState());
      if (appGetit.user == null) {
        await appGetit.getUser(id: authServiceLGetit.currentUser!.id);
      }

      students = await appGetit.getStudentForDriver(
        id: authServiceLGetit.currentUser!.id,
      );
      for (var element in students!) {
        log(element.toString());
      }
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
      log(bus.toString());
      emit(SuccessState());
    } catch (e) {
      emit(ErrorState(messge: e.toString()));
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
      for (var element in tripStopsList) {
        log(element.toString());
      }
      await appGetit.sendTripStops(tripStopsList: tripStopsList);

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

      emit(SuccessAddNewTripState());
      add(UpdateMapDataEvent());
    } catch (e) {
      log(e.toString());
      emit(ErrorState(messge: " ${e.toString()}"));
    }
  }

  FutureOr<void> updateMapData(
    UpdateMapDataEvent event,
    Emitter<DriverTripState> emit,
  ) async {
    mapMarkers.clear();
    mapPolylines.clear();

    if (appGetit.user != null &&
        appGetit.user!.latitude != null &&
        appGetit.user!.longitude != null) {
      mapMarkers.add(
        Marker(
          markerId: MarkerId('driver_location'), // ID مميز لماركر السائق
          position: LatLng(appGetit.user!.latitude!, appGetit.user!.longitude!),
          infoWindow: InfoWindow(title: "Driver Location"),
          // هنا التعديل: استخدم busIcon بدلاً من defaultMarkerWithHue
          icon:
              busIcon ??
              BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ), //
        ),
      );

      List<LatLng> polylinePoints = [];
      // نقطة بداية المسار هي موقع السائق
      polylinePoints.add(
        LatLng(appGetit.user!.latitude!, appGetit.user!.longitude!),
      );

      // إضافة ماركرز الطلاب ونقاطهم للمسار
      if (students != null) {
        for (var student in students!) {
          if (student.latitude != null && student.longitude != null) {
            // البحث عن حالة الطالب في الرحلة الحالية
            final studentTripStatus = studentsTrip?.firstWhere(
              (ts) => ts.studentId == student.id && ts.tripId == trip?.id,
            );

            BitmapDescriptor studentIcon;
            if (studentTripStatus?.pickupStatus == true) {
              // إذا تم الالتقاط، استخدم أيقونة مخصصة (إذا وجدت) أو أيقونة خضراء
              studentIcon =
                  pickedUpChildMarkerIcon ??
                  BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen,
                  );
            } else {
              // إذا لم يتم الالتقاط، استخدم أيقونة حسب الجنس
              if (student.gender == 'Male') {
                //
                studentIcon =
                    maleChildMarkerIcon ??
                    BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange,
                    );
              } else if (student.gender == 'Female') {
                //
                studentIcon =
                    femaleChildMarkerIcon ??
                    BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange,
                    );
              } else {
                studentIcon = BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange,
                ); // أيقونة افتراضية
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
            polylinePoints.add(
              LatLng(student.latitude!, student.longitude!),
            ); // إضافة نقطة الطالب للمسار
          }
        }
      }

      mapMarkers.add(
        Marker(
          markerId: MarkerId("My little Route "),
          position: LatLng(24.5412682270113, 46.6648522263772),
          infoWindow: InfoWindow(title: "My little Route school"),
          icon: school!,
        ),
      );
       polylinePoints.add(
              LatLng(24.5412682270113, 46.6648522263772),
            ); 
      // إضافة المسار (Polyline)
      if (polylinePoints.length > 1) {
         mapPolylines.add(
          Polyline(
            polylineId: PolylineId('driver_route'),
            points: polylinePoints,
            color: StyleColor.buttonBlue,  
            width: 5,
          ),
        );

        // mapPolylines.add(
        //   Polyline(
        //     polylineId: PolylineId('my little route 2'),
        //     points: polylinePoints,
        //     color: StyleColor.buttonBlue, // لون المسار الذي طلبته
        //     width: 5,
        //   ),
        // );
      }
    } else {
      // رسالة تسجيل (log) في حال عدم توفر موقع السائق
      log("Driver's location is not available to draw the map.");
      // يمكنك هنا أيضًا إرسال حالة خطأ إلى واجهة المستخدم إذا أردت التعامل مع هذه الحالة بشكل مرئي
      // emit(ErrorState(messge: "Driver location not available to display map."));
    }

    // إرسال حالة MapDataReadyState لإعلام واجهة المستخدم بأن بيانات الخريطة جاهزة
    emit(MapDataReadyState());
  }

  FutureOr<void> createReturnTripMethod(
    CreateReturnTripEvent event,
    Emitter<DriverTripState> emit,
  ) async {
    if (sharedPrefs.getString('"trip_id"') != null) {
      add(GetTripEvent());
    } else {
      try {
        trip = await appGetit.createTrip(
          newTrip: TripModel(
            busId: bus!.id!,
            driverId: appGetit.user!.id!,
            tripType: 'dropoff',
            scheduledTime: DateTime.now(),
            status: 'started',
          ),
        );

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
        for (var element in tripStopsList) {
          log(element.toString());
        }
        await appGetit.sendTripStops(tripStopsList: tripStopsList);

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

        emit(SuccessAddNewTripState());
        await sharedPrefs.clear();
        add(UpdateMapDataEvent());
      } catch (e) {
        log(e.toString());
        emit(ErrorState(messge: " ${e.toString()}"));
      }
    }
  }

  FutureOr<void> getTripMethod(
    GetTripEvent event,
    Emitter<DriverTripState> emit,
  ) async {
    try {
      if (sharedPrefs.getString("trip_id") != null) {
        log("start bloc getTripMethod");
        trip = await appGetit.getTrip(
          tripId: sharedPrefs.getString("trip_id").toString(),
        );

        tripStops = await appGetit.getTripStops(
          tripId: sharedPrefs.getString("trip_id").toString(),
        );
        studentsTrip = await appGetit.getStudentsTrip(
          tripId: sharedPrefs.getString("trip_id").toString(),
        );
        emit(SucssesGetTripState());
      } else {
        add(CreateTripEvent());
      }
    } on Exception catch (e) {
      log("sqqqq");
      emit(ErrorGetTripState(messge: e.toString()));
      log(e.toString());
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
      school = await _getBytesFromAsset(
        "assets/image/marker-Kindergarten.png",
        100,
      );
      log("Custom markers loaded successfully.");
    } catch (e) {
      log("Error loading custom markers: $e");
    }
  }

  FutureOr<void> updateStudentStatusMethod(
    UpdateStudentStatusEvent event,
    Emitter<DriverTripState> emit,
  ) async {
    try {
      log("start bloc updateStudentStatusMethod");
      TripStudentsModel? updatedStudentTrip;

      if (event.tripType == 'pickup') {
        updatedStudentTrip = await appGetit.updateStudentPickupStatus(
          studentTrip: TripStudentsModel(
            tripId: event.tripStudent.tripId,
            studentId: event.student.id!,
            pickupStatus: event.newStatus,
            pickupTime: event.newStatus ? DateTime.now() : null,
            dropoffStatus: false,
          ),
        );
      } else if (event.tripType == 'dropoff') {
        updatedStudentTrip = await appGetit.updateStudentDropOffStatus(
          studentTrip: TripStudentsModel(
            tripId: event.tripStudent.tripId,
            studentId: event.student.id!,
            dropoffStatus: event.newStatus,
            dropoffTime: event.newStatus ? DateTime.now() : null,
            pickupStatus: event.tripStudent.pickupStatus,
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
              tripStudent.tripId == event.tripStudent.tripId &&
              tripStudent.studentId == event.student.id,
        );

        if (index != -1) {
          studentsTrip![index] = updatedStudentTrip;
        }
      }
      log("--------------------------------");
      for (var element in students!) {
        log("--------------------------------");
        log(element.toString());
      }
      emit(SuccessState());
    } catch (e) {
      emit(ErrorState(messge: e.toString()));
    }
  }

  FutureOr<void> endTripMethod(
    EndTripEvent event,
    Emitter<DriverTripState> emit,
  ) {}

  //fucntions

  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:my_little_route/features/driver/driver_trip/bloc/driver_trip_bloc.dart';
// import 'package:my_little_route/features/driver/driver_trip/widgets/button/elvated_button.dart';
// import 'package:my_little_route/features/driver/driver_trip/widgets/switch/student_switch.dart';
// import 'package:my_little_route/models/student/students_models.dart';
// import 'package:my_little_route/models/trip_students/trip_students_model.dart';
// import 'package:my_little_route/style/style_color.dart';
// import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';

// class DriverTripScreen extends StatelessWidget {
//   const DriverTripScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bloc = context.read<DriverTripBloc>();
//     return Scaffold(
//       appBar: AppBar(title: Text("DriverCurrentTripScreen")),
//       body: BlocBuilder<DriverTripBloc, DriverTripState>(
//         builder: (context, state) {
//           if (state is LoadingState) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is ErrorState) {
//             return Center(child: Text("Error: ${state.messge}"));
//           } else if (bloc.students == null ||
//               bloc.students!.isEmpty ||
//               bloc.trip == null ||
//               bloc.studentsTrip == null) {
//             bloc.add(CreateTripEvent());
//             return const Center(
//               child: Text("No active trip or students data available."),
//             );
//           }
//           return ListView(
//             children: [
//               Container(
//                 width: context.getWidth(),
//                 height: context.getHeight() * .4,
//                 decoration: BoxDecoration(color: StyleColor.buttonOrange),
//               ),
//               SizedBox(height: 10),

//               Container(
//                 width: context.getWidth(),

//                 decoration: BoxDecoration(
//                   color: StyleColor.mintCream,
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: bloc.students!.length,
//                         itemBuilder: (context, index) {
//                           StudentsModel student = bloc.students![index];
//                           final studentTripToday = bloc.studentsTrip!.firstWhere(
//                             (studentTrip) =>
//                                 studentTrip.tripId == bloc.trip!.id &&
//                                 student.id == studentTrip.studentId,

//                             orElse: () {
//                               log(
//                                 "Warning: TripStudentsModel not found for student ${student.id} in trip ${bloc.trip!.id}",
//                               );
//                               return TripStudentsModel(
//                                 tripId: bloc.trip!.id!,
//                                 studentId: student.id!,
//                                 pickupStatus: false,
//                                 dropoffStatus: false,
//                                 pickupTime: null,
//                                 dropoffTime: null,
//                               );
//                             },
//                           );
//                           log("a");
//                           log(studentTripToday.toString());
//                           return StudentSwitch(
//                             value: studentTripToday.pickupStatus,
//                             title: student.name,
//                             onChanged: (newStatus) {
//                               bloc.add(
//                                 UpdateStudentStatusEvent(
//                                   newStatus: newStatus,
//                                   studentId: student.id!,
//                                   triptId: studentTripToday.tripId,
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                     ElvatedButton(
//                       buttonTitle:  "endtrip",
//                       buttoColor: StyleColor.buttonBlue,
//                       onPressed: () {

//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_little_route/features/driver/driver_trip/bloc/driver_trip_bloc.dart';
import 'package:my_little_route/features/driver/driver_trip/widgets/switch/student_switch.dart';
import 'package:my_little_route/models/student/students_models.dart';
import 'package:my_little_route/models/trip_students/trip_students_model.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';
import 'dart:math' as math; // تأكد أن الاستيراد بهذا الشكل

class DriverTripScreen extends StatelessWidget {
  const DriverTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DriverTripBloc>();
    return Scaffold(
      appBar: AppBar(title: Text("DriverCurrentTripScreen")),
      body: BlocConsumer<DriverTripBloc, DriverTripState>(
        listener: (context, state) {
          if (state is SuccessAddNewTripState ||
              state is SuccessState ||
              state is MapDataReadyState) {
            if (bloc.mapController != null && bloc.mapPolylines.isNotEmpty) {
              List<LatLng> allPoints = [];
              for (var polyline in bloc.mapPolylines) {
                allPoints.addAll(polyline.points);
              }
              for (var marker in bloc.mapMarkers) {
                allPoints.add(marker.position);
              }

              if (allPoints.isNotEmpty) {
                // التعديل هنا: استخدام دالة anonymous مع math.min و math.max
                double minLat = allPoints
                    .map((p) => p.latitude)
                    .reduce((a, b) => math.min(a, b));
                double maxLat = allPoints
                    .map((p) => p.latitude)
                    .reduce((a, b) => math.max(a, b));
                double minLng = allPoints
                    .map((p) => p.longitude)
                    .reduce((a, b) => math.min(a, b));
                double maxLng = allPoints
                    .map((p) => p.longitude)
                    .reduce((a, b) => math.max(a, b));

                LatLngBounds bounds = LatLngBounds(
                  southwest: LatLng(minLat, minLng),
                  northeast: LatLng(maxLat, maxLng),
                );
                bloc.mapController!.animateCamera(
                  CameraUpdate.newLatLngBounds(bounds, 50.0),
                );
              }
            }
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ErrorState) {
            return Center(child: Text("Error: ${state.messge}"));
          } else if (state is TripEndedState) {
            return Center(child: Text("Trip has ended."));
          } else if (bloc.students == null ||
              bloc.students!.isEmpty ||
              bloc.trip == null ||
              bloc.studentsTrip == null ||
              bloc.appGetit.user == null ||
              bloc.appGetit.user!.latitude == null ||
              bloc.appGetit.user!.longitude == null) {
            return const Center(
              child: Text("Loading trip or student data, please wait..."),
            );
          }

          return Column(
            children: [
              Container(
                width: context.getWidth(),
                height: context.getHeight() * .4,
                // decoration: BoxDecoration(color: StyleColor.buttonOrange),
                child: GoogleMap(
                  
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      bloc.appGetit.user!.latitude!,
                      bloc.appGetit.user!.longitude!,
                    ),
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    bloc.mapController = controller;
                    bloc.add(UpdateMapDataEvent());
                  },
                  markers: bloc.mapMarkers,
                  polylines: bloc.mapPolylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  width: context.getWidth(),
                  decoration: BoxDecoration(
                    color: StyleColor.mintCream,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Students on Trip",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: bloc.students!.length,
                          itemBuilder: (context, index) {
                            StudentsModel student = bloc.students![index];
                            final studentTripToday = bloc.studentsTrip!.firstWhere(
                              (studentTrip) =>
                                  studentTrip.tripId == bloc.trip!.id &&
                                  student.id == studentTrip.studentId,
                              orElse: () {
                                log(
                                  "Warning: TripStudentsModel not found for student ${student.id} in trip ${bloc.trip!.id}",
                                );
                                return TripStudentsModel(
                                  tripId: bloc.trip!.id!,
                                  studentId: student.id!,
                                  pickupStatus: false,
                                  dropoffStatus: false,
                                  pickupTime: null,
                                  dropoffTime: null,
                                );
                              },
                            );
                            log("a");
                            log(studentTripToday.toString());
                            return StudentSwitch(
                              value: studentTripToday.pickupStatus,
                              title: student.name,
                              onChanged: (newStatus) {
                                bloc.add(
                                  UpdateStudentStatusEvent(
                                    newStatus: newStatus,
                                    student: student,
                                    tripStudent: studentTripToday,
                                    tripType: bloc.trip!.tripType!,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            bloc.add(EndTripEvent());
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: StyleColor.buttonOrange,
                            minimumSize: Size(context.getWidth() * 0.8, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "End Trip",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

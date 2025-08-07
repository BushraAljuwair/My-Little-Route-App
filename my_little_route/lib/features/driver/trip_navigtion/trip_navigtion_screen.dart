import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_little_route/features/driver/driver_trip/widgets/switch/student_switch.dart';
import 'package:my_little_route/features/driver/trip_navigtion/bloc/trip_navigtion_bloc.dart';
import 'package:my_little_route/models/student/students_models.dart';
import 'package:my_little_route/style/style_color.dart';
import 'package:my_little_route/utilities/extensions/screens/get_size_screen.dart';

class TripNavigtionScreen extends StatelessWidget {
  const TripNavigtionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TripNavigtionBloc>();

    return Scaffold(
      appBar: AppBar(title: Text("DriverCurrentTripScreen")),
      body: BlocConsumer<TripNavigtionBloc, TripNavigtionState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ErrorGetInfoState || state is ErrorPickUpState) {
            return Center(child: Text("error with get info or pickup "));
          } else if (state is SucssesGetTripState ||
              state is MapDataReadyState) {
            return Column(
              children: [
                SizedBox(
                  width: context.getWidth(),
                  height: context.getHeight() * .4,

                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        bloc.driverLiveLocation!.latitude,
                        bloc.driverLiveLocation!.longitude,
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
                              final studentTripToday = bloc.studentsTrip!
                                  .firstWhere(
                                    (studentTrip) =>
                                        studentTrip.tripId == bloc.trip!.id &&
                                        student.id == studentTrip.studentId,
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
                              // bloc.add(EndTripEvent());
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("wait"));
        },
      ),
    );
  }
}

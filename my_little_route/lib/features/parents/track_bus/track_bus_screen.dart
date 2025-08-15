// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:my_little_route/features/parents/track_bus/bloc/track_bus_bloc.dart';

// // class TrackBusScreen extends StatelessWidget {
// //   const TrackBusScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocProvider(
// //       create: (context) => TrackBusBloc()..add(LoadInitialDataEvent()),
// //       child: Builder(
// //         builder: (context) {
// //           final bloc = context.read<TrackBusBloc>();

// //           return Scaffold(
// //             appBar: AppBar(title: Text("TrackBusScreen")),
// //             body: BlocConsumer<TrackBusBloc, TrackBusState>(
// //               listener: (context, state) {
// //                 // هذا الجزء يستمع فقط للتغييرات التي نريدها
// //                 if (state is TrackBusLocationUpdated) {
// //                   bloc.animateCameraToCurrentLocation(state.locationData);
// //                 }
// //               },
// //               builder: (context, state) {
// //                 // 1. إذا كانت الحالة تحميل، اعرض مؤشر التحميل
// //                 if (state is TrackBusLoading) {
// //                   return const Center(child: CircularProgressIndicator());
// //                 }

// //                 // 2. إذا كانت هناك حالة خطأ، اعرض رسالة الخطأ
// //                 if (state is TrackBusError) {
// //                   return Center(child: Text(state.message.toString()));
// //                 }

// //                 // 3. إذا تم تحميل البيانات أو تحديثها، اعرض الخريطة
// //                 if (state is TrackBusLoaded || state is TrackBusLocationUpdated) {
// //                    return GoogleMap(
// //                     initialCameraPosition: CameraPosition(
// //                       target: bloc.sourceLocation,
// //                       zoom: 13.5,
// //                     ),
// //                     // نستخدم مجموعة الـ markers مباشرة
// //                     markers: bloc.markers,
// //                     onMapCreated: (controller) {
// //                       bloc.googleMapController.complete(controller);
// //                       // استدعاء حدث جلب المسار بعد تهيئة الخريطة
// //                       bloc.add(GetPloyLineEvent());
// //                     },
// //                     polylines: bloc.polylines,
// //                   );
// //                 }

// //                 // الحالة الافتراضية إذا حدث خطأ غير متوقع
// //                 return const Center(child: Text("حدث خطأ غير متوقع"));
// //               },
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:my_little_route/features/parents/track_bus/bloc/track_bus_bloc.dart';
// import 'package:my_little_route/style/style_color.dart';

// class TrackBusScreen extends StatelessWidget {
//   const TrackBusScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => TrackBusBloc()..add(LoadInitialDataEvent()),
//       child: Builder(
//         builder: (context) {
//           final bloc = context.read<TrackBusBloc>();
//           return Scaffold(
//             appBar: AppBar(title: Text("data")),
//             body: BlocBuilder<TrackBusBloc, TrackBusState>(
//               builder: (context, state) {
//                 if (state is ErrorState) {
//                   return Center(child: Text(state.message));
//                 }
//                 if (state is SuccessState) {
//                   return GoogleMap(
//                     initialCameraPosition: CameraPosition(
//                       target: bloc.sourceLocation,
//                       zoom: 13.5,
//                     ),
//                     markers: {
//                       // Marker(
//                       //   markerId: MarkerId("source"),
//                       //   position: bloc.sourceLocation,
//                       //   icon: bloc.busIcon,
//                       // ),
//                       Marker(
//                         markerId: MarkerId("destination"),
//                         position: bloc.destinationLocation,
//                         icon: bloc.houseIcon,
//                       ),
//                       if (bloc.locationData != null)
//                         Marker(
//                           markerId: MarkerId("currentLocation"),
//                           position: LatLng(
//                             bloc.locationData!.latitude!,
//                             bloc.locationData!.longitude!,
//                           ),
//                             icon: bloc.busIcon,
//                         ),
//                     },
//                     onMapCreated: (controller) {
//                       bloc.googleMapController.complete(controller);
//                     },
//                     polylines: {
//                       Polyline(
//                         polylineId: PolylineId("route"),
//                         points: bloc.polyPoints,
//                         color: StyleColor.blue,
//                       ),
//                     },
//                   );
//                 }
//                 return Center(child: Text("loading"));
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }









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
            appBar: AppBar(title: Text("data")),
            body: BlocBuilder<TrackBusBloc, TrackBusState>(
              builder: (context, state) {
                if (state is ErrorState) {
                  return Center(child: Text(state.message));
                }
                if (state is SuccessState) {
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      // استخدم موقع الباص كنقطة بداية
                      target: bloc.sourceLocation,
                      zoom: 13.5,
                    ),
                    markers: bloc.markers, // استخدم المجموعة المحدثة من bloc
                    onMapCreated: (controller) {
                      bloc.googleMapController.complete(controller);
                    },
                    polylines: bloc.polylines, // استخدم المجموعة المحدثة من bloc
                  );
                }
                return Center(child: Text("loading"));
              },
            ),
          );
        },
      ),
    );
  }
}

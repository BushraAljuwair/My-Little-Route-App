import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';




class ParentsHomeScreen extends StatelessWidget {
  const ParentsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ParentsHomeScreen"),),
    );
  }
}








// class ParentsHomeScreen extends StatefulWidget {
//   const ParentsHomeScreen({super.key});

//   @override
//   State<ParentsHomeScreen> createState() => _ParentsHomeScreenState();
// }

// class _ParentsHomeScreenState extends State<ParentsHomeScreen> {
    
//   var markers = HashSet<Marker>(); //collagction
//   late BitmapDescriptor customMarker;



// Future<void>  getCustomMarker()async{
//   customMarker=await BitmapDescriptor.fromAssetImage( ImageConfiguration(size: Size(40, 40)),  'assets/image/marker-child.png');
//   }

//   @override
//   void initState() {
//     getCustomMarker();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("ParentsHomeScreen")),

//       body: GoogleMap(
//         onMapCreated: (controller) {
//           setState(() {
//             markers.add(
//               Marker(
//                 markerId: MarkerId(controller.mapId.toString()),
//                 position: LatLng(24.64301720908129, 46.69635165284417),
//                 infoWindow: InfoWindow(
//                   title: 'this is ddd',
//                   snippet: 'aaaaaaaaaaaaaaaaaaaaaaa'

//                 ),
//               icon: customMarker
//               ),
//             );
//           });
//         },
//         initialCameraPosition: CameraPosition(
//           target: LatLng(24.64301720908129, 46.69635165284417),
//           zoom: 19,
//         ),

//         markers: markers,
//       ),
//     );
//   }
// }

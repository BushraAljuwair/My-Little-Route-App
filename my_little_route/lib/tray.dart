import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart'; // ستحتاجين هذه الحزمة إذا أردتِ تحويل الإحداثيات إلى عنوان

class Tray extends StatefulWidget {
  const Tray({super.key});

  @override
  State<Tray> createState() => _TrayState();
}

class _TrayState extends State<Tray> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // مجموعة لتخزين العلامات (Markers) التي ستظهر على الخريطة
  Set<Marker> _markers = {};

  // تم تحديث الإحداثيات لتكون في الرياض
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.7136, 46.6753), // إحداثيات الرياض (مركز تقريبي)
    zoom: 14.4746,
  );

  // تم تحديث الإحداثيات لتكون في الرياض (مثال على موقع آخر داخل الرياض)
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(24.7963, 46.6660), // مثال: إحداثيات قريبة من بحيرة وادي حنيفة
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    super.initState();
    // عند بدء التطبيق، يمكننا إضافة علامة أولية إذا أردنا
    _markers.add(
      Marker(
        markerId: const MarkerId('initialLocation'),
        position: _kGooglePlex.target,
        infoWindow: const InfoWindow(title: 'الموقع الأولي'),
      ),
    );
  }

  // دالة تُستدعى عند النقر على الخريطة
  void _onMapTap(LatLng latLng) async {
    // طباعة الإحداثيات إلى الكونسول
    log('تم النقر على الإحداثيات: Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}');

    // يمكنك هنا إضافة علامة (Marker) في المكان الذي تم النقر عليه
    setState(() {
      _markers.clear(); // مسح العلامات القديمة إذا أردتِ علامة واحدة فقط
      _markers.add(
        Marker(
          markerId: MarkerId(latLng.toString()), // معرف فريد للعلامة
          position: latLng, // موقع العلامة هو مكان النقر
          infoWindow: InfoWindow(
            title: 'الموقع المحدد',
            snippet: 'خط الطول: ${latLng.latitude.toStringAsFixed(4)}, خط العرض: ${latLng.longitude.toStringAsFixed(4)}',
          ),
        ),
      );
    });

    // (اختياري) يمكنك أيضاً تحويل الإحداثيات إلى عنوان هنا
    try {
      // تم تغيير localeIdentifier إلى locale واستخدام Locale object
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude, );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
        log('العنوان التقريبي: $address');
        // يمكنك تحديث الـ InfoWindow للعلامة بالعنوان أيضاً
        setState(() {
          _markers.clear();
          _markers.add(
            Marker(
              markerId: MarkerId(latLng.toString()),
              position: latLng,
              infoWindow: InfoWindow(
                title: 'الموقع المحدد',
                snippet: address,
              ),
            ),
          );
        });
      }
    } catch (e) {
      print('لم يتم العثور على عنوان لهذا الموقع: $e');
    }

    // يمكنك عرض رسالة للمستخدم في شريط سفلي (SnackBar)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تحديد الموقع: Lat: ${latLng.latitude.toStringAsFixed(4)}, Lng: ${latLng.longitude.toStringAsFixed(4)}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: _onMapTap, // هنا نضيف الدالة التي ستُستدعى عند النقر
        markers: _markers, // عرض العلامات على الخريطة
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: const Text('إلى البحيرة!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

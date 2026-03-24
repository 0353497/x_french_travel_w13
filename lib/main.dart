import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:x_french_travel/pages/homepage.dart';
import 'package:x_french_travel/providers/booking_provider.dart';

void main() {
  runApp(const MainApp());
  Get.put<BookingProvider>(BookingProvider());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(home: Homepage());
  }
}

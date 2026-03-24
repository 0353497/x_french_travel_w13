import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';

class MyBookingsCalPage extends StatefulWidget {
  const MyBookingsCalPage({super.key});

  @override
  State<MyBookingsCalPage> createState() => _MyBookingsCalPageState();
}

class _MyBookingsCalPageState extends State<MyBookingsCalPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("My Booking CAL"),
      ),
      body: Container(),
    );
  }

  void init() async {
    await Future.delayed(400.milliseconds);
    if (mounted) {
      showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:x_french_travel/pages/homepage.dart';
import 'package:x_french_travel/pages/my_bookings_cal_page.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.to(() => Homepage()),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("My Bookings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Text("List of my bookings"),
                IconButton(onPressed: () {}, icon: Icon(Icons.calendar_month)),
                IconButton(
                  onPressed: () {},
                  icon: Text(
                    "\$",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 200,
                    child: Card(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Center(child: Text("${index + 1}")),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("first name, Last name \n hotel name"),
                                Text("date to date"),
                                Text("2 adults, 0 children, 1 room"),
                                Row(
                                  spacing: 12,
                                  children: [
                                    Text("For sightseeing"),
                                    Text("Pay with cash"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [Text("€299")],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => Get.to(() => MyBookingsCalPage()),
                child: SizedBox(
                  height: 60,
                  width: Get.width * .3,
                  child: Center(child: Text("MY Booking CAL")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

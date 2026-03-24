import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:x_french_travel/models/booking.dart';
import 'package:x_french_travel/pages/homepage.dart';
import 'package:x_french_travel/pages/my_bookings_cal_page.dart';
import 'package:x_french_travel/providers/booking_provider.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  final BookingProvider provider = Get.find<BookingProvider>();

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
                itemCount: provider.bookedBookings.length,
                itemBuilder: (context, index) {
                  final Booking booking = provider.bookedBookings[index];
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
                                Text(
                                  "${booking.firstName}, ${booking.lastName} \n ${booking.hotelName}",
                                ),
                                Text(
                                  "${DateFormat("EEE, m d, y").format(booking.checkInDate)} to ${DateFormat("EEE, m d, y").format(booking.checkOutDate)}",
                                ),
                                Text(
                                  "${booking.adults} adults, ${booking.adults} children, ${booking.rooms} room",
                                ),
                                Row(
                                  spacing: 12,
                                  children: [
                                    if (booking.isForBusiness)
                                      Text("For sightseeing"),
                                    if (!booking.isForBusiness)
                                      Text("For sight seeing"),
                                    Text("Pay with ${booking.paymentMethod}"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [Text("€${booking.price}")],
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

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
  bool isStartDateDescending = true;
  bool isPriceDescending = true;

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
                IconButton(
                  key: Key("SortByStartDate"),
                  onPressed: sortByStartDate,
                  icon: Icon(Icons.calendar_month),
                ),
                IconButton(
                  key: Key("SortByPrice"),
                  onPressed: sortByPrice,
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
                    key: Key("BookingCard_$index"),
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
                                  key: Key("BookingDate_$index"),
                                ),
                                Text(
                                  "${booking.adults} adults, ${booking.children} children, ${booking.rooms} room",
                                  key: Key("BookingGuests_$index"),
                                ),
                                Row(
                                  spacing: 12,
                                  children: [
                                    if (booking.isForBusiness)
                                      Text("For business with a meeting room"),
                                    if (!booking.isForBusiness)
                                      Text("For sightseeing"),
                                    Text("Pay with ${booking.paymentMethod}"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "€${booking.price}",
                                      key: Key("BookingPrice_$index"),
                                    ),
                                  ],
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
                key: Key("MyBookingCAL"),
                onPressed: () => Get.to(() => MyBookingsCalPage()),
                child: SizedBox(
                  height: 60,
                  width: Get.width * .3,
                  child: Center(child: Text("My Booking CAL")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sortByStartDate() {
    provider.bookedBookings.sort((a, b) {
      return isStartDateDescending
          ? b.checkInDate.compareTo(a.checkInDate)
          : a.checkInDate.compareTo(b.checkInDate);
    });
    setState(() {
      isStartDateDescending = !isStartDateDescending;
    });
  }

  void sortByPrice() {
    provider.bookedBookings.sort((a, b) {
      return isPriceDescending
          ? b.price.compareTo(a.price)
          : a.price.compareTo(b.price);
    });
    setState(() {
      isPriceDescending = !isPriceDescending;
    });
  }
}

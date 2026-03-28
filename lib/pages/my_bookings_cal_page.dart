import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:x_french_travel/models/booking.dart';
import 'package:x_french_travel/providers/booking_provider.dart';

class MyBookingsCalPage extends StatefulWidget {
  const MyBookingsCalPage({super.key});

  @override
  State<MyBookingsCalPage> createState() => _MyBookingsCalPageState();
}

class _MyBookingsCalPageState extends State<MyBookingsCalPage> {
  final BookingProvider provider = Get.find<BookingProvider>();
  DateTime visibleMonth = DateTime(
    DateTime(2025, 10, 8).year,
    DateTime(2025, 10, 8).month,
    1,
  );

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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  key: Key("CalendarPrevMonth"),
                  onPressed: () {
                    setState(() {
                      visibleMonth = DateTime(
                        visibleMonth.year,
                        visibleMonth.month - 1,
                        1,
                      );
                    });
                  },
                  icon: Icon(Icons.chevron_left),
                ),
                Spacer(),
                Text(
                  DateFormat("MMMM y").format(visibleMonth),
                  key: Key("CalendarMonthLabel"),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Spacer(),

                IconButton(
                  key: Key("CalendarNextMonth"),
                  onPressed: () {
                    setState(() {
                      visibleMonth = DateTime(
                        visibleMonth.year,
                        visibleMonth.month + 1,
                        1,
                      );
                    });
                  },
                  icon: Icon(Icons.chevron_right),
                ),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                key: Key("CalendarDaysGrid"),
                itemCount: DateUtils.getDaysInMonth(
                  visibleMonth.year,
                  visibleMonth.month,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final DateTime day = DateTime(
                    visibleMonth.year,
                    visibleMonth.month,
                    index + 1,
                  );
                  final bool hasBooking = _bookingsOnDate(day).isNotEmpty;
                  final bool isToday = _isSameDay(DateTime.now(), day);

                  return InkWell(
                    key: Key("CalendarDay_${day.day}"),
                    onTap: () {
                      if (hasBooking) {
                        provider.setStartDateFilter(day);
                        Get.back();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isToday
                            ? Colors.blue.shade100
                            : hasBooking
                            ? Colors.orange.shade200
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isToday
                              ? Colors.blue.shade700
                              : hasBooking
                              ? Colors.deepOrange
                              : Colors.grey,
                          width: isToday ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "${day.day}",
                          style: TextStyle(
                            color: isToday
                                ? Colors.blue.shade900
                                : hasBooking
                                ? Colors.deepOrange.shade900
                                : Colors.black87,
                            fontWeight: isToday || hasBooking
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                          key: Key(
                            hasBooking
                                ? "HighlightedBookingDate_${day.month}_${day.day}"
                                : "CalendarDayText_${day.month}_${day.day}",
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Tap a highlighted booking date to filter My Bookings",
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  List<Booking> _bookingsOnDate(DateTime day) {
    return provider.bookedBookings.where((booking) {
      return _isSameDay(booking.checkInDate, day);
    }).toList();
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

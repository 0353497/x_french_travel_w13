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
  DateTime visibleMonth = DateTime(2025, 9, 1);
  DateTime? selectedDate;

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
                Text(
                  DateFormat("MMMM y").format(visibleMonth),
                  key: Key("CalendarMonthLabel"),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Spacer(),
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
                  final bool isSelected = _isSameDay(selectedDate, day);

                  return InkWell(
                    key: Key("CalendarDay_${day.day}"),
                    onTap: () {
                      setState(() {
                        selectedDate = day;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue.shade200
                            : hasBooking
                            ? Colors.orange.shade200
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: hasBooking ? Colors.deepOrange : Colors.grey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "${day.day}",
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
            SizedBox(height: 16),
            Text(
              "Booking details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ..._buildSelectedDateDetails(),
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

  List<Widget> _buildSelectedDateDetails() {
    if (selectedDate == null) {
      return [Text("Select a date to view booking records")];
    }

    final List<Booking> selectedBookings = _bookingsOnDate(selectedDate!);
    if (selectedBookings.isEmpty) {
      return [
        Text(
          "No booking records for ${DateFormat("MMM d").format(selectedDate!)}",
          key: Key("CalendarSelectedDateNoRecords"),
        ),
      ];
    }

    return selectedBookings.asMap().entries.map((entry) {
      final int index = entry.key;
      final Booking booking = entry.value;
      return Text(
        "${booking.hotelName} starting on ${DateFormat("MMMM d").format(booking.checkInDate)}",
        key: Key(
          index == 0
              ? "CalendarBookingDetail_${booking.checkInDate.month}_${booking.checkInDate.day}"
              : "CalendarBookingDetail_${booking.checkInDate.month}_${booking.checkInDate.day}_$index",
        ),
      );
    }).toList();
  }
}

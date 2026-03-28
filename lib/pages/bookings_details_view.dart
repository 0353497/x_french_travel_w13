import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:x_french_travel/pages/booking_confirm_page.dart';
import 'package:x_french_travel/services/json_reader.dart';

class BookingsView extends StatefulWidget {
  const BookingsView({super.key, required this.hotel});
  final dynamic hotel;

  @override
  State<BookingsView> createState() => _BookingsViewState();
}

class _BookingsViewState extends State<BookingsView> {
  @override
  void initState() {
    super.initState();
    init();
  }

  late Future<dynamic> hotel = JsonReader.readHotel(widget.hotel["hotel_id"]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("Booking"),
      ),
      body: FutureBuilder(
        future: hotel,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!asyncSnapshot.hasData) {
            return Center(child: Text("No hotel details available"));
          }

          final dynamic details = asyncSnapshot.data;
          final List<dynamic> ratings =
              details["guest_reviews"]["ratings_categories"] as List<dynamic>;
          final List<dynamic> reviews =
              details["guest_reviews"]["reviews_objects"] as List<dynamic>;
          final List<dynamic> rooms = details["rooms"] as List<dynamic>;

          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  color: Colors.blueGrey.shade50,
                  child: Text(
                    widget.hotel["hotel_name"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                TabBar(
                  tabs: [
                    Tab(key: Key("GuestReviews"), text: "Guest reviews"),
                    Tab(key: Key("RoomSelection"), text: "Room selection"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.black,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ratings",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    ...ratings.map((entry) {
                                      return RatingsWidget(
                                        entry: Map<String, dynamic>.from(entry),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Reviews",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: reviews.length,
                                      itemBuilder: (context, index) {
                                        final review = reviews[index];
                                        return SizedBox(
                                          width: 200,
                                          child: Card(
                                            child: Column(
                                              children: [
                                                Row(
                                                  spacing: 12,
                                                  children: [
                                                    CircleAvatar(
                                                      child: Text(
                                                        review["username"]
                                                            .toString()[0],
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          review["username"]
                                                              .toString(),
                                                        ),
                                                        Text(review["country"]),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Text(review["review_text"]),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "Rooms",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: rooms.length,
                                    itemBuilder: (context, index) {
                                      final room = rooms[index];
                                      return ListTile(
                                        onTap: () => Get.to(
                                          () => BookingConfirmPage(
                                            hotel: widget.hotel,
                                            room: room,
                                          ),
                                        ),

                                        title: Text("${room["room_type"]}"),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Bed: ${room["room_bed_type"]}",
                                            ),
                                            Text(
                                              "Total number of guests: ${room["room_total_number_of_guests"]}",
                                            ),
                                            Text(
                                              (room["room_features"]
                                                      as List<dynamic>)
                                                  .join(", "),
                                            ),
                                          ],
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.euro, size: 18),
                                            Text(
                                              "${room["room_price_for_one_night"]}",
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void init() async {
    hotel = JsonReader.readHotel(widget.hotel["hotel_id"]);
    setState(() {});
  }
}

class RatingsWidget extends StatelessWidget {
  const RatingsWidget({super.key, required this.entry});
  final Map<String, dynamic> entry;
  double get value => entry.entries.first.value as double;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(entry.entries.first.key), Text("$value")],
        ),
        LayoutBuilder(
          builder: (contex, constraints) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 10,
                  width: constraints.maxWidth,
                ),
                Container(
                  height: 10,
                  width: constraints.maxWidth * (value / 10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

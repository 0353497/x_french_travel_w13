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
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
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
                            Text(
                              widget.hotel["hotel_name"],
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
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
                                    Text("Ratings"),
                                    RatingsWidget(
                                      entry: asyncSnapshot
                                          .data["guest_reviews"]["ratings_categories"][1],
                                    ),
                                    RatingsWidget(
                                      entry: asyncSnapshot
                                          .data["guest_reviews"]["ratings_categories"][0],
                                    ),
                                    RatingsWidget(
                                      entry: asyncSnapshot
                                          .data["guest_reviews"]["ratings_categories"][2],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Reviews"),
                                  Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          (asyncSnapshot
                                                      .data["guest_reviews"]["reviews_objects"]
                                                  as List)
                                              .length,
                                      itemBuilder: (context, index) {
                                        final review = asyncSnapshot
                                            .data["guest_reviews"]["reviews_objects"][index];
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
                          SizedBox(
                            height: 150,
                            child: Center(
                              child: Text(
                                widget.hotel["hotel_name"],
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Rooms"),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount:
                                        (asyncSnapshot.data["rooms"] as List)
                                            .length,
                                    itemBuilder: (context, index) {
                                      final room =
                                          asyncSnapshot.data["rooms"][index];
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
                                              "Bed: ${room["room_bed_type"]}, Total Number of guests ${room["room_total_number_of_guests"]}",
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              child: Text(
                                                (room["room_features"]
                                                        as List<dynamic>)
                                                    .reduce((a, b) => "$a, $b,")
                                                    .toString(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Text(
                                          "€${room["room_price_for_one_night"]}",
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
  get value => entry.entries.first.value as double;
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

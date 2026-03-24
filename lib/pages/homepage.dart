import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:get/route_manager.dart';
import 'package:x_french_travel/pages/bookings_details_view.dart';
import 'package:x_french_travel/pages/my_bookings_page.dart';
import 'package:x_french_travel/services/json_reader.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  final TextEditingController hotelController = TextEditingController();

  late List completeHotels = [];
  List filteredHotels = [];
  bool isOpenFilter = false;
  double filteredRating = 0;
  double distance = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("The Alps'Hotel🇫🇷"),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => MyBookingsPage()),
            icon: Icon(Icons.person_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: hotelController,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            filteredHotels = completeHotels;
                          });
                        }
                        setState(() {
                          filteredHotels = completeHotels
                              .where(
                                (hotel) => hotel["hotel_name"]
                                    .toString()
                                    .contains(value),
                              )
                              .toList();
                        });
                      },
                      decoration: InputDecoration(
                        hint: Text("Search a hotel name"),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isOpenFilter = !isOpenFilter;
                      });
                    },
                    icon: Icon(Icons.menu),
                  ),
                ],
              ),
            ),
            if (isOpenFilter)
              SizedBox(
                height: 200,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Rating"),
                        for (int i = 0; i < 5; i++)
                          IconButton(
                            onPressed: () => addStarValue(),
                            icon: getStar(i),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Dist"),
                        Expanded(
                          child: SizedBox(
                            width: 200,
                            child: Slider(
                              semanticFormatterCallback: (value) {
                                return "$value".padRight(2, "0");
                              },
                              max: 10,
                              showValueIndicator:
                                  ShowValueIndicator.alwaysVisible,
                              min: 0,
                              divisions: 100,
                              value: distance,
                              onChanged: (value) {
                                setState(() {
                                  distance = value;
                                });
                              },
                            ),
                          ),
                        ),
                        Text("${distance.toPrecision(1)}"),
                      ],
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredHotels.length,
                itemBuilder: (context, index) {
                  final dynamic hotel = filteredHotels[index];
                  return ListTile(
                    key: ValueKey(hotel["hotel_id"]),
                    onTap: () {
                      if (hotel["hotel_id"] == 1000 ||
                          hotel["hotel_id"] == 1008) {
                        Get.to(() => BookingsView(hotel: hotel));
                      }
                    },
                    leading: Image.asset(
                      "assets/image/${hotel["hotel_cover_image"]}",
                    ),
                    title: Text(hotel["hotel_name"]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 12,
                      children: [
                        Row(
                          children: [
                            Text(hotel["hotel_rating"].toString()),
                            Row(
                              children: [
                                for (int i = 0; i < 5; i++)
                                  getStarListItem(hotel["hotel_rating"], i),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          "${hotel["hotel_to_ski_distance"]} from Alp's ski lift",
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      child: Text("Book it"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void init() async {
    completeHotels = await JsonReader.readHotels();
    filteredHotels = completeHotels;
    setState(() {});
  }

  void addStarValue() {
    if (filteredRating > 5) {
      setState(() {
        filteredRating = 0;
      });
      return;
    }
    setState(() {
      filteredRating += .5;
    });
  }

  Widget getStar(int i) {
    if (i < filteredRating - .5) return Icon(Icons.star, color: Colors.yellow);
    if (i < filteredRating && i > filteredRating - 1.5) {
      return Icon(Icons.star_half, color: Colors.yellow);
    }
    return Icon(Icons.star);
  }

  Widget getStarListItem(double rating, int i) {
    double checkValue = rating * .5;
    if (i < checkValue - .5) return Icon(Icons.star, color: Colors.yellow);
    if (i < checkValue && i > checkValue - 1.5) {
      return Icon(Icons.star_half, color: Colors.yellow);
    }
    return SizedBox();
  }
}

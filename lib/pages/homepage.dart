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
  double distance = 10.0;
  String searchTerm = "";

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
                      key: Key("HotelSearch"),
                      controller: hotelController,
                      textInputAction: TextInputAction.search,
                      onChanged: (value) {
                        searchTerm = value;
                        applyFilters();
                      },
                      onSubmitted: (_) => applyFilters(),
                      decoration: InputDecoration(
                        hint: Text("Search a hotel name"),
                      ),
                    ),
                  ),
                  IconButton(
                    key: Key("FilterList"),
                    onPressed: () {
                      setState(() {
                        isOpenFilter = !isOpenFilter;
                      });
                      applyFilters();
                    },
                    icon: Icon(
                      isOpenFilter ? Icons.filter_list_off : Icons.filter_list,
                    ),
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
                            key: Key("FilterStar$i"),
                            onPressed: addStarValue,
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
                              key: Key("DistanceSlider"),
                              semanticFormatterCallback: (value) {
                                return value.toStringAsFixed(1);
                              },
                              max: 10,
                              showValueIndicator:
                                  ShowValueIndicator.alwaysVisible,
                              min: 1,
                              divisions: 90,
                              value: distance,
                              onChanged: (value) {
                                setState(() {
                                  distance = value;
                                });
                                applyFilters();
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
                          "${hotel["hotel_to_ski_distance"]} km from Alps' ski lift",
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        if (_isBookableHotel(hotel["hotel_id"])) {
                          Get.to(() => BookingsView(hotel: hotel));
                        }
                      },
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
    applyFilters();
  }

  void addStarValue() {
    if (filteredRating >= 5) {
      setState(() {
        filteredRating = 0;
      });
      applyFilters();
      return;
    }
    setState(() {
      filteredRating += .5;
    });
    applyFilters();
  }

  void applyFilters() {
    final String normalizedSearch = searchTerm.trim().toLowerCase();
    final double minHotelRating = filteredRating * 2;

    final List<dynamic> nextHotels = completeHotels.where((hotel) {
      final String hotelName = hotel["hotel_name"].toString().toLowerCase();
      final double hotelRating = (hotel["hotel_rating"] as num).toDouble();
      final double hotelDistance = (hotel["hotel_to_ski_distance"] as num)
          .toDouble();

      final bool matchesText =
          normalizedSearch.isEmpty || hotelName.contains(normalizedSearch);
      final bool matchesRating =
          !isOpenFilter || filteredRating == 0 || hotelRating >= minHotelRating;
      final bool matchesDistance = !isOpenFilter || hotelDistance <= distance;
      return matchesText && matchesRating && matchesDistance;
    }).toList();

    setState(() {
      filteredHotels = nextHotels;
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

  bool _isBookableHotel(int hotelId) {
    return hotelId == 1000 || hotelId == 1008;
  }
}

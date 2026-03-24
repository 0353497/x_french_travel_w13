import 'dart:convert';

import 'package:flutter/services.dart';

class JsonReader {
  static Future<dynamic> readJson(String path) async {
    final json = await rootBundle.loadString(path);
    final data = await jsonDecode(json);
    return data;
  }

  static Future<List> readHotels() async {
    final hotels = await readJson("assets/data/hotels.json");
    return hotels;
  }

  static Future<dynamic> readHotel(int id) async {
    final hotel = await readJson("assets/data/hotels_details.$id.json");
    return hotel;
  }
}

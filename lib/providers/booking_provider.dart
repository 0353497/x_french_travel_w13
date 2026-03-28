import 'package:get/get.dart';
import 'package:x_french_travel/models/booking.dart';

class BookingProvider extends GetxController {
  final List<Booking> bookedBookings = [
    Booking(
      firstName: "Alice",
      lastName: "Martin",
      hotelName: "Hotel Le Coucou Méribel",
      checkInDate: DateTime(2025, 10, 8),
      checkOutDate: DateTime(2025, 10, 10),
      adults: 2,
      children: 1,
      rooms: 1,
      isForBusiness: false,
      paymentMethod: "Credit Card",
      price: 480,
    ),
    Booking(
      firstName: "Ethan",
      lastName: "Dubois",
      hotelName: "L'Appart à Méribel",
      checkInDate: DateTime(2025, 10, 21),
      checkOutDate: DateTime(2025, 10, 23),
      adults: 3,
      children: 2,
      rooms: 1,
      isForBusiness: false,
      paymentMethod: "E-pay",
      price: 530,
    ),
    Booking(
      firstName: "Sophie",
      lastName: "Moreau",
      hotelName: "Residence Pierre & Vacances Premium les Crets",
      checkInDate: DateTime(2025, 12, 15),
      checkOutDate: DateTime(2025, 12, 18),
      adults: 2,
      children: 0,
      rooms: 1,
      isForBusiness: true,
      paymentMethod: "Credit Card",
      price: 900,
    ),
  ];
}

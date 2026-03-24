class Booking {
  final String firstName;
  final String lastName;
  final String hotelName;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int adults;
  final int children;
  final int rooms;
  final bool isForBusiness;
  final String paymentMethod;
  final int price;

  Booking({
    required this.firstName,
    required this.lastName,
    required this.checkInDate,
    required this.checkOutDate,
    required this.adults,
    required this.children,
    required this.rooms,
    required this.isForBusiness,
    required this.paymentMethod,
    required this.hotelName,
    required this.price,
  });
}

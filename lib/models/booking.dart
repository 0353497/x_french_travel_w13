class Booking {
  final String firstName;
  final String lastName;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int adults;
  final int children;
  final int rooms;
  final bool isForBusiness;
  final String paymentMethod;

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
  });
}

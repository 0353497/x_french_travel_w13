import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:x_french_travel/models/booking.dart';
import 'package:x_french_travel/pages/my_bookings_page.dart';
import 'package:x_french_travel/providers/booking_provider.dart';

class BookingConfirmPage extends StatefulWidget {
  const BookingConfirmPage({super.key, this.hotel, this.room});
  final dynamic hotel;
  final dynamic room;

  @override
  State<BookingConfirmPage> createState() => _BookingConfirmPageState();
}

class _BookingConfirmPageState extends State<BookingConfirmPage> {
  final formkey = GlobalKey<FormState>();
  bool isForBusiness = false;
  String paymentMethod = "";
  int price = 0;
  int get rooms {
    final int adults = int.tryParse(adultController.text) ?? 1;
    final int children = int.tryParse(childController.text) ?? 0;
    final int totalGuests = adults + children;
    final int roomCapacity =
        (widget.room["room_total_number_of_guests"] as num?)?.toInt() ?? 2;
    final int computed = (totalGuests / roomCapacity).ceil();
    return computed < 1 ? 1 : computed;
  }

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController adultController = TextEditingController.fromValue(
    TextEditingValue(text: "1"),
  );
  final TextEditingController childController = TextEditingController.fromValue(
    TextEditingValue(text: "0"),
  );

  final TextEditingController checkInDateController = TextEditingController();
  final TextEditingController checkOutDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    adultController.addListener(_recalculatePrice);
    childController.addListener(_recalculatePrice);
    checkInDateController.addListener(_recalculatePrice);
    checkOutDateController.addListener(_recalculatePrice);
    _recalculatePrice();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    adultController.dispose();
    childController.dispose();
    checkInDateController.dispose();
    checkOutDateController.dispose();
    super.dispose();
  }

  final BookingProvider provider = Get.find<BookingProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("Booking Confirm"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("You are going to reserve:"),
            SizedBox(
              height: 100,
              child: Center(child: Text(widget.hotel["hotel_name"])),
            ),
            Container(
              height: 60,
              color: Colors.white,
              child: Column(
                children: [
                  Text(widget.room["room_type"]),
                  Text(
                    "Bed: ${widget.room["room_bed_type"]} Total number of guests: ${widget.room["room_total_number_of_guests"]}",
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Form"),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: firstNameController,
                            key: Key("FirstName"),
                            decoration: InputDecoration(
                              label: Text("First Name"),
                              hint: Text("First Name"),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return "value can not be empty";
                              }
                              if (value.isEmpty) {
                                return "value can not be empty";
                              }
                              if (value.length > 15) {
                                return "value can not be more than 15 char";
                              }
                              if (value.contains(RegExp(r'[0-9]'))) {
                                return "no numbers";
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: lastNameController,
                            key: Key("LastName"),
                            validator: (value) {
                              if (value == null) {
                                return "value can not be empty";
                              }
                              if (value.isEmpty) {
                                return "value can not be empty";
                              }
                              if (value.length > 15) {
                                return "value can not be more than 15 char";
                              }
                              if (value.contains(RegExp(r'[0-9]'))) {
                                return "no numbers";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: Text("Last Name"),
                              hint: Text("Last Name"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: TextFormField(
                            key: Key("CheckInDate"),
                            controller: checkInDateController,
                            validator: (value) {
                              if (value == null) {
                                return "value can not be empty";
                              }
                              if (value.isEmpty) {
                                return "value can not be empty";
                              }
                              String testvalue = value.replaceAll("-", "/");
                              if (DateFormat(
                                    "MMM d yy",
                                  ).tryParseLoose(testvalue) !=
                                  null) {
                                return null;
                              }
                              if (DateFormat(
                                    "M/d/y",
                                  ).tryParseLoose(testvalue) ==
                                  null) {
                                return "not a valid datetime";
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              label: Text("Check-in date"),
                              hint: Text("Check-in date"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            key: Key("CheckOutDate"),
                            controller: checkOutDateController,
                            validator: (value) {
                              if (value == null) {
                                return "value can not be empty";
                              }
                              if (value.isEmpty) {
                                return "value can not be empty";
                              }
                              String testvalue = value.replaceAll("-", "/");
                              if (DateFormat(
                                    "y/M/d",
                                  ).tryParseLoose(testvalue) ==
                                  null) {
                                return "not a valid datetime";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: Text("Check-out date"),
                              hint: Text("Check-out date"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(widget.room["room_type"]),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: TextFormField(
                            key: Key("Adults"),
                            controller: adultController,
                            decoration: InputDecoration(
                              label: Text("Adults"),
                              hint: Text("Adults"),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]'),
                              ),
                            ],
                            validator: (value) {
                              if (value == null) {
                                return "value can not be empty";
                              }
                              if (value.isEmpty) {
                                return "value can not be empty";
                              }
                              if (int.tryParse(value) == null) {
                                return "value is not a number";
                              }
                              int numberValue = int.parse(value);
                              if (numberValue < 1 || numberValue > 5) {
                                return "1 -5";
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            key: Key("Children"),
                            controller: childController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]'),
                              ),
                            ],
                            decoration: InputDecoration(
                              label: Text("Children"),
                              hint: Text("Children"),
                            ),
                            validator: (value) {
                              if (value == null) return null;
                              if (int.tryParse(value) == null) {
                                return "value is not a number";
                              }
                              int numberValue = int.parse(value);

                              if (int.tryParse(adultController.value.text) ==
                                  null) {
                                return "fill adults first ";
                              }
                              if (numberValue < 0 ||
                                  numberValue >
                                      (int.parse(adultController.value.text) *
                                          2)) {
                                return "0 - ${int.parse(adultController.value.text) * 2}, 2 * adults ";
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Room"),
                              Text("$rooms", key: Key("RoomsCountValue")),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Travel for business?"),
                        RadioGroup(
                          groupValue: isForBusiness,
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              isForBusiness = value;
                            });
                            _recalculatePrice();
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Radio<bool>(
                                      key: Key("sightseeing"),
                                      value: false,
                                    ),
                                    Text("For sightseeing"),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Radio<bool>(
                                    key: Key("ForBusiness"),
                                    value: true,
                                  ),
                                  Text(
                                    "+ €150 \nFor business with a meeting room",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              Text("Which way to pay?"),
                              Row(
                                children: [
                                  RadioGroup<String>(
                                    groupValue: paymentMethod,
                                    onChanged: (value) {
                                      if (value == null) return;
                                      setState(() {
                                        paymentMethod = value;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Radio(
                                          key: Key("Cash"),
                                          value: "Cash",
                                          enabled: false,
                                        ),
                                        Text("Cash"),
                                        Radio(
                                          key: Key("CreditCard"),
                                          value: "Credit Card",
                                        ),
                                        Text("Credit card"),
                                        Radio(
                                          key: Key("E-pay"),
                                          value: "E-pay",
                                        ),
                                        Text("E-Pay"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "€ $price",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                      width: double.maxFinite,
                      child: ElevatedButton(
                        key: Key("BookNow"),
                        onPressed: () {
                          if (formkey.currentState?.validate() ?? false) {
                            Get.dialog(
                              Dialog(
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Are you going to book this room?"),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => Get.back(),
                                            child: Text("No"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                              provider.addBooking(
                                                Booking(
                                                  firstName: firstNameController
                                                      .value
                                                      .text,
                                                  lastName: lastNameController
                                                      .value
                                                      .text,
                                                  checkInDate:
                                                      _parseBookingDate(
                                                        checkInDateController
                                                            .value
                                                            .text,
                                                      ) ??
                                                      DateTime.now(),
                                                  checkOutDate:
                                                      _parseBookingDate(
                                                        checkOutDateController
                                                            .value
                                                            .text,
                                                      ) ??
                                                      DateTime.now(),
                                                  adults: int.parse(
                                                    adultController.value.text,
                                                  ),
                                                  children:
                                                      int.tryParse(
                                                        childController
                                                            .value
                                                            .text,
                                                      ) ??
                                                      0,
                                                  rooms: rooms,
                                                  isForBusiness: isForBusiness,
                                                  paymentMethod: paymentMethod,
                                                  hotelName: widget
                                                      .hotel["hotel_name"],
                                                  price: price,
                                                ),
                                              );
                                              Get.to(() => MyBookingsPage());
                                            },
                                            child: Text("Yes"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            Get.dialog(
                              Dialog(
                                child: Text(
                                  "error please fill in the form correctly",
                                ),
                              ),
                            );
                          }
                        },
                        child: Text("Book now"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime? _parseBookingDate(String rawValue) {
    final String value = rawValue.trim().replaceAll("-", "/");
    if (value.isEmpty) return null;

    final List<DateFormat> formats = <DateFormat>[
      DateFormat("y/M/d"),
      DateFormat("M/d/y"),
      DateFormat("d/M/yy"),
      DateFormat("MMM d yy"),
    ];

    for (final DateFormat format in formats) {
      final DateTime? parsed = format.tryParseLoose(value);
      if (parsed != null) return parsed;
    }
    return null;
  }

  int _nightsCount() {
    final DateTime? checkIn = _parseBookingDate(checkInDateController.text);
    final DateTime? checkOut = _parseBookingDate(checkOutDateController.text);
    if (checkIn == null || checkOut == null) {
      return 1;
    }

    final int nights = checkOut.difference(checkIn).inDays;
    return nights < 1 ? 1 : nights;
  }

  void _recalculatePrice() {
    final int roomPrice =
        (widget.room["room_price_for_one_night"] as num?)?.toInt() ?? 0;
    final int basePrice = roomPrice * _nightsCount() * rooms;
    final int totalPrice = basePrice + (isForBusiness ? 150 : 0);

    if (mounted) {
      setState(() {
        price = totalPrice;
      });
    }
  }
}

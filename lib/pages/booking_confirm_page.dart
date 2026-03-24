import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:x_french_travel/pages/my_bookings_page.dart';

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
  TextEditingController adultController = TextEditingController.fromValue(
    TextEditingValue(text: "1"),
  );
  TextEditingController childController = TextEditingController.fromValue(
    TextEditingValue(text: "0"),
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      price = widget.room["room_price_for_one_night"];
    });
  }

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
            Text("You are going to reserve"),
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
                            key: Key("FirstName"),
                            decoration: InputDecoration(
                              label: Text("first Name"),
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
                              hint: Text("Childern"),
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
                            children: [Text("Room"), Text("1")],
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
                            if (value) {
                              price += 150;
                            } else {
                              price -= 150;
                            }
                            setState(() {
                              isForBusiness = value;
                            });
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
                              Text("Wich way to pay?"),
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
                                        Radio(value: "Cash", enabled: false),
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
}

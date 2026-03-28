// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/instance_manager.dart';
import 'package:integration_test/integration_test.dart';
import 'package:x_french_travel/main.dart';
import 'package:x_french_travel/providers/booking_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  int step = 1;
  const Duration holdDuration = Duration(milliseconds: 10);

  Get.put<BookingProvider>(BookingProvider());

  testWidgets("The Alps’ Hotel", (tester) async {
    Future<void> nextStep(String description) async {
      await tester.pumpAndSettle();
      print("Step No: $step,$description");
      step++;
      await Future.delayed(holdDuration);
    }

    Finder finderIn(Finder parent, Finder child) {
      return find.descendant(of: parent, matching: child);
    }

    int parsePriceFromText(String text) {
      return int.parse(text.replaceAll(RegExp(r'[^0-9]'), ''));
    }

    await tester.pumpWidget(const MainApp());

    expect(find.text("The Alps'Hotel🇫🇷"), findsOneWidget);
    await nextStep("Application startup");

    await tester.scrollUntilVisible(
      find.text("L'Appart à Méribel"),
      500,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text("L'Appart à Méribel"), findsOneWidget);
    await nextStep("Scroll to the bottom of the hotel list");

    await tester.enterText(find.byKey(Key("HotelSearch")), "Meribel");
    expect(find.text("Appartement Meribel"), findsOneWidget);
    await nextStep(
      "Perform a search after entering the search term in the search bar",
    );

    await tester.tap(find.text("Appartement Meribel"));
    await tester.pumpAndSettle();
    expect(find.text("Booking"), findsOneWidget);
    await nextStep('Click the listing item "Appartement Meribel"');

    await tester.tap(find.byKey(Key("GuestReviews")));
    expect(find.text("Reviews"), findsOneWidget);
    await nextStep("Click the Guest reviews tab button");

    await tester.scrollUntilVisible(
      find.text("Miles"),
      500,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text("Miles"), findsOneWidget);
    await nextStep(
      'Scroll down the Reviews list to the 4th Review (published by "Miles")',
    );

    await tester.tap(find.byKey(Key("RoomSelection")));
    expect(find.text("Room selection"), findsOneWidget);
    await nextStep("Click the Room selection label button");

    await tester.scrollUntilVisible(
      find.text("Great family Room"),
      500,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text("Great family Room"), findsOneWidget);
    await nextStep('Scroll down the room list to the "Great Family Room" item');

    await tester.tap(find.text("Great family Room"));
    await nextStep('Click the "Great Family Room" item');

    await tester.enterText(find.byKey(Key("FirstName")), "Taylor");
    expect(find.text("Taylor"), findsOneWidget);
    await nextStep("Enter First Name");

    await tester.enterText(find.byKey(Key("LastName")), "Hutchinson");
    expect(find.text("Hutchinson"), findsOneWidget);
    await nextStep("Enter Last Name");

    await tester.enterText(find.byKey(Key("CheckInDate")), "Dec 15 25");
    final TextFormField checkInFieldStep12 = tester.widget<TextFormField>(
      find.byKey(Key("CheckInDate")),
    );
    expect(checkInFieldStep12.controller?.text, "Dec 15 25");
    await nextStep("Enter check-in date");

    await tester.enterText(find.byKey(Key("CheckOutDate")), "02/12/25D");
    final TextFormField checkOutFieldStep13 = tester.widget<TextFormField>(
      find.byKey(Key("CheckOutDate")),
    );
    expect(checkOutFieldStep13.controller?.text, "02/12/25D");
    await nextStep("Enter check-out date");

    await tester.enterText(find.byKey(Key("Adults")), "4");
    expect(find.byKey(Key("RoomsCountValue")), findsOneWidget);
    await nextStep("Enter the number of adults");

    await tester.enterText(find.byKey(Key("Children")), "3");
    expect(find.text("3"), findsWidgets);
    await nextStep("Enter the number of children");

    await tester.tap(find.byKey(Key("E-pay")));
    final Radio<String> cashRadio = tester.widget<Radio<String>>(
      find.byWidgetPredicate(
        (widget) => widget is Radio<String> && widget.value == "Cash",
      ),
    );
    expect(cashRadio.enabled, isFalse);

    await nextStep("Click the E-Pay radio button");

    await tester.tap(find.byKey(Key("BookNow")));
    await tester.pumpAndSettle();
    expect(
      find.text("error please fill in the form correctly"),
      findsOneWidget,
    );
    await nextStep('Click the "Book now" button');

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key("CheckOutDate")), "2025-12-19");
    final TextFormField checkOutFieldStep18 = tester.widget<TextFormField>(
      find.byKey(Key("CheckOutDate")),
    );
    expect(checkOutFieldStep18.controller?.text, "2025-12-19");
    await nextStep("Change check-out date");

    await tester.tap(find.byKey(Key("BookNow")));
    await tester.pumpAndSettle();
    expect(find.text("Are you going to book this room?"), findsOneWidget);
    await nextStep('Click the "Book now" button');

    await tester.tap(find.text("Yes"));
    await tester.pumpAndSettle();
    expect(find.text("My Bookings"), findsOneWidget);
    expect(find.textContaining("Taylor, Hutchinson"), findsOneWidget);
    await nextStep(
      'Click "Yes" in the pop-up window to confirm your reservation.',
    );

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();
    await nextStep("Click the back button to the Home page");

    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(find.text("My Bookings"), findsOneWidget);
    await nextStep("Click top right corner icon");

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();
    await nextStep("Click the back button to the Home page");

    await tester.tap(find.byKey(Key("FilterList")));
    await tester.pumpAndSettle();
    expect(find.text("Rating"), findsOneWidget);
    expect(find.text("Dist"), findsOneWidget);
    await nextStep('Click the "Filter List" icon');

    for (int i = 0; i < 9; i++) {
      await tester.tap(find.byKey(Key("FilterStar0")));
      await tester.pumpAndSettle();
    }

    await tester.drag(find.byKey(Key("DistanceSlider")), const Offset(50, 0));
    await tester.pumpAndSettle();
    await tester.showKeyboard(find.byKey(Key("HotelSearch")));
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(
      find.text("Residence Pierre & Vacances Premium les Crets"),
      findsOneWidget,
    );
    await nextStep(
      "Select a Rating of 4.5 stars and a Dist of 6.9, then press the search key on the keyboard.",
    );

    await tester.tap(
      find.text("Residence Pierre & Vacances Premium les Crets"),
    );
    await tester.pumpAndSettle();
    await nextStep(
      'Click the listing item "Residence Pierre & Vacances Premium les Crets"',
    );

    await tester.tap(find.byKey(Key("RoomSelection")));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text("Two-Bedroom Apartment - Open Mountain View"),
      500,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text("Two-Bedroom Apartment - Open Mountain View"));
    await tester.pumpAndSettle();
    expect(find.text("Booking Confirm"), findsOneWidget);
    await nextStep(
      """Click the Room selection label button & Scroll down the room list to the "Two-Bedroom Apartment - Open Mountain View" item & Click the item""",
    );
    await tester.enterText(find.byKey(Key("FirstName")), "Taylor");

    await tester.enterText(find.byKey(Key("LastName")), "Hutchinson");
    await tester.enterText(find.byKey(Key("CheckInDate")), "Dec 21 25");

    await tester.enterText(find.byKey(Key("CheckOutDate")), "2025-12-23");

    await tester.enterText(find.byKey(Key("Adults")), "4");

    await tester.enterText(find.byKey(Key("Children")), "8");

    await nextStep(
      "Enter check-in date & Enter check-out date & Enter the number of adults & Enter the number of children",
    );

    await tester.tap(find.byKey(Key("ForBusiness")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Book now"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Yes"));
    await tester.pumpAndSettle();

    await nextStep(
      'Click For business with a meeting room radio button & Click the "Book now" button  & Click "Yes" in the pop-up window',
    );

    expect(find.text("My Bookings"), findsOneWidget);

    await tester.tap(find.byKey(Key("SortByStartDate")));
    await tester.pumpAndSettle();
    final Finder bookingCard0 = find.byKey(Key("BookingCard_0"));
    expect(bookingCard0, findsOneWidget);
    expect(
      finderIn(
        bookingCard0,
        find.textContaining("Residence Pierre & Vacances Premium les Crets"),
      ),
      findsOneWidget,
    );
    await nextStep(
      'Click the "Calendar Clock" icon - sort by Start Date (descending)',
    );

    await tester.tap(find.byKey(Key("SortByStartDate")));
    await tester.pumpAndSettle();
    expect(
      finderIn(
        find.byKey(Key("BookingCard_0")),
        find.textContaining("Alice, Martin"),
      ),
      findsOneWidget,
    );
    await nextStep(
      'Click the "Calendar Clock" icon - sort by Start Date (ascending)',
    );

    await tester.tap(find.byKey(Key("SortByStartDate")));
    await tester.pumpAndSettle();
    expect(
      finderIn(
        find.byKey(Key("BookingCard_0")),
        find.textContaining("Residence Pierre & Vacances Premium les Crets"),
      ),
      findsOneWidget,
    );
    await nextStep(
      'Click the "Calendar Clock" icon - sort by Start Date (descending)',
    );

    await tester.tap(find.byKey(Key("SortByPrice")));
    await tester.pumpAndSettle();
    final Text priceDesc0Text = tester.widget<Text>(
      find.byKey(Key("BookingPrice_0")),
    );
    final Text priceDesc1Text = tester.widget<Text>(
      find.byKey(Key("BookingPrice_1")),
    );
    expect(
      parsePriceFromText(priceDesc0Text.data ?? "") >=
          parsePriceFromText(priceDesc1Text.data ?? ""),
      isTrue,
    );
    await nextStep(
      'Click the "Attach Money" icon - sort by Price (descending)',
    );

    await tester.tap(find.byKey(Key("SortByPrice")));
    await tester.pumpAndSettle();
    final Text priceAsc0Text = tester.widget<Text>(
      find.byKey(Key("BookingPrice_0")),
    );
    final Text priceAsc1Text = tester.widget<Text>(
      find.byKey(Key("BookingPrice_1")),
    );
    expect(
      parsePriceFromText(priceAsc0Text.data ?? "") <=
          parsePriceFromText(priceAsc1Text.data ?? ""),
      isTrue,
    );
    await nextStep('Click the "Attach Money" icon - sort by Price (ascending)');

    await tester.tap(find.byKey(Key("SortByPrice")));
    await tester.pumpAndSettle();
    final Text priceDescAgain0Text = tester.widget<Text>(
      find.byKey(Key("BookingPrice_0")),
    );
    final Text priceDescAgain1Text = tester.widget<Text>(
      find.byKey(Key("BookingPrice_1")),
    );
    expect(
      parsePriceFromText(priceDescAgain0Text.data ?? "") >=
          parsePriceFromText(priceDescAgain1Text.data ?? ""),
      isTrue,
    );
    await nextStep(
      'Click the "Attach Money" icon - sort by Price (descending)',
    );

    await tester.tap(find.byKey(Key("MyBookingCAL")));
    await tester.pumpAndSettle();
    expect(find.text("My Booking CAL"), findsWidgets);
    await nextStep('Click the "My Booking CAL" button');

    await tester.pumpAndSettle();
    expect(find.byKey(Key("CalendarMonthLabel")), findsOneWidget);
    expect(find.byKey(Key("HighlightedBookingDate_10_8")), findsOneWidget);
    expect(find.byKey(Key("HighlightedBookingDate_10_21")), findsOneWidget);
    await nextStep(
      "Click the control to move to the NEXT month in the calendar",
    );

    await tester.tap(find.byKey(Key("CalendarNextMonth")));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("CalendarNextMonth")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("CalendarDay_21")));
    await tester.pumpAndSettle();
    await nextStep("Click December 21 to view booking records");

    await tester.tap(find.byKey(Key("MyBookingCAL")));
    await tester.pumpAndSettle();
    await nextStep("Go back and display My Booking CAL");

    await tester.tap(find.byKey(Key("CalendarNextMonth")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("CalendarNextMonth")));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key("CalendarDay_15")));
    await tester.pumpAndSettle();
    await nextStep("Click December 15 to view booking records");
  });
}

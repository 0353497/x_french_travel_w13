// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:x_french_travel/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  int step = 1;
  //   All STEPs need to be held on for at least 10 seconds, and the "Step No: $Steps_No,$Description of the Action" should be
  // logged on the "output" area, such as terminal, debug area or console.
  testWidgets("The Alps’ Hotel", (tester) async {
    Future<void> nextStep(String description) async {
      await tester.pumpAndSettle();
      print("Step No: $step, $description");
      step++;
      await Future.delayed(Duration(milliseconds: 1));
    }

    await tester.pumpWidget(const MainApp());
    await nextStep("Application startup");

    await tester.scrollUntilVisible(
      find.text("L'Appart à Méribel"),
      500,
      scrollable: find.byType(Scrollable).last,
    );
    await nextStep("Scroll to the bottom of the hotel list");

    await tester.enterText(find.byType(TextField), "Appartement Meribel");
    await nextStep(
      "Perform a search after entering the search term in the search bar",
    );

    await tester.tap(find.text("Appartement Meribel").last);
    await nextStep('Click the listing item "Appartement Meribel"');

    await tester.tap(find.byKey(Key("GuestReviews")));
    await nextStep("Click the Guest reviews tab button");

    await tester.scrollUntilVisible(
      find.text("Miles"),
      500,
      scrollable: find.byType(Scrollable).last,
    );
    await nextStep(
      'Scroll down the Reviews list to the 4th Review (published by "Miles")',
    );

    await tester.tap(find.byKey(Key("RoomSelection")));
    await nextStep("Click the Room selection label button");

    await tester.scrollUntilVisible(
      find.text("Great family Room"),
      500,
      scrollable: find.byType(Scrollable).last,
    );
    await nextStep('Scroll down the room list to the "Great Family Room" item');

    await tester.tap(find.text("Great family Room"));
    await nextStep('Click the "Great Family Room" item');

    await tester.enterText(find.byKey(Key("FirstName")), "Taylor");
    await nextStep("Enter First Name");

    await tester.enterText(find.byKey(Key("LastName")), "Hutchinson");
    await nextStep("Enter Last Name");

    await tester.enterText(find.byKey(Key("CheckInDate")), "02/15/25");
    await nextStep("Enter check-in date");

    await tester.enterText(find.byKey(Key("CheckOutDate")), "02/15/25D");
    await nextStep("Enter check-out date");

    await tester.enterText(find.byKey(Key("Adults")), "4");
    await nextStep("Enter the number of adults");

    await tester.enterText(find.byKey(Key("Children")), "3");
    await nextStep("Enter the number of children");

    await tester.tap(find.byKey(Key("E-pay")));
    await nextStep("Click the E-Pay radio button");

    await tester.tap(find.text("Book now"));
    await nextStep('Click the "Book now" button');

    await tester.tap(find.text("Book now"));
    await tester.enterText(find.byKey(Key("CheckOutDate")), "2025-12-19");
    await nextStep("Change check-out date");

    await tester.tap(find.text("Book now"));
    await nextStep('Click the "Book now" button');

    await tester.tap(find.text("Yes"));
    await nextStep(
      'Click "Yes" in the pop-up window to confirm your reservation.',
    );

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await nextStep("Click the back button to the Home page");

    await tester.tap(find.byIcon(Icons.person_outline));
    await nextStep("Click top right corner icon");

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await nextStep("Click the back button to the Home page");

    await tester.tap(find.byIcon(Icons.menu));
    await nextStep('Click the "Filter List" icon');

    for (var i = 0; i < 9; i++) {
      await tester.tap(find.byIcon(Icons.star).first);
    }

    await tester.drag(find.byType(Slider), const Offset(50, 0));
    await nextStep(
      "Select a Rating of 4.5 stars and a Dist of 6.9, then press the search key on the keyboard.",
    );

    await tester.tap(
      find.text("Residence Pierre & Vacances Premium les Crets"),
    );
    await nextStep(
      'Click the listing item "Residence Pierre & Vacances Premium les Crets',
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
    await nextStep(
      """Click the Room selection label button & Scroll down the room list to the "Two-Bedroom Apartment - Open Mountain View" item & Click the item""",
    );
    await tester.enterText(find.byKey(Key("FirstName")), "Taylor");

    await tester.enterText(find.byKey(Key("LastName")), "Hutchinson");
    await tester.enterText(find.byKey(Key("CheckInDate")), "Dec 21 25");

    await tester.enterText(find.byKey(Key("CheckOutDate")), "23/12/25");

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
  });
}

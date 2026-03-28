import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:integration_test/integration_test.dart';
import 'package:x_french_travel/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("slider test", (tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    const offset = Offset(50, 0);
    await tester.drag(find.byType(Slider), offset);
    await tester.pumpAndSettle();

    final sliderFinder = find.byType(Slider);
    final Slider slider = tester.widget<Slider>(sliderFinder);
    if (kDebugMode) {
      print('Slider Value: ${slider.value}, Offset: $offset');
      print('Slider Value: ${slider.value.toPrecision(1)}, Offset: $offset');
    }

    await Future.delayed(5.seconds);
  });
}

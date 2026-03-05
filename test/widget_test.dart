import 'package:flutter_test/flutter_test.dart';

import 'package:weather_mine/main.dart';

void main() {
  testWidgets('WeatherApp builds successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WeatherApp());

    // Verify that the app builds without crashing.
    expect(find.byType(WeatherApp), findsOneWidget);
  });
}

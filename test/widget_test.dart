import 'package:flutter_test/flutter_test.dart';
import 'package:time_machine/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TimeMachineApp());
    expect(find.byType(TimeMachineApp), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:fly2/app/app.dart';

void main() {
  testWidgets('app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const Fly2App());
    expect(find.text('Live'), findsOneWidget);
  });
}

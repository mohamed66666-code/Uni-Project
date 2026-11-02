import 'package:flutter_test/flutter_test.dart';
import 'package:university_app/main.dart';

void main() {
  testWidgets('UniversityApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const UniversityApp());

    // Verify that login screen is displayed.
    expect(find.text('بوابة الطالب الجامعية'), findsOneWidget);
    expect(find.text('دخول'), findsOneWidget);
  });
}

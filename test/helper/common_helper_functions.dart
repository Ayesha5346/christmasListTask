import 'package:flutter_test/flutter_test.dart';

Future<void> enterTextIntoField(WidgetTester tester, Finder elementFinder, String text)async{
  await tester.ensureVisible(elementFinder);
  await tester.tap(elementFinder);
  await tester.enterText(elementFinder, text);
  await tester.pumpAndSettle(const Duration(seconds: 1));
}
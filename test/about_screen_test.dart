import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:img_to_pdf_app/constants/app_theme.dart';
import 'package:img_to_pdf_app/screens/about_screen.dart';

void main() {
  testWidgets('AboutScreen displays AP Programming Tech trademark and mission',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const AboutScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('AP Programming Tech™'), findsOneWidget);
    expect(find.text('Created with care by AP Programming Tech.'), findsOneWidget);
    expect(find.text('Our Mission'), findsOneWidget);
    expect(
      find.text('To provide everyone with a simple, reliable and completely free PDF conversion experience.'),
      findsOneWidget,
    );
    expect(find.text('Product Highlights'), findsOneWidget);
    expect(find.text('Completely free to use.'), findsOneWidget);
    expect(find.text('© 2026 AP Programming Tech. All rights reserved.'), findsOneWidget);
  });
}

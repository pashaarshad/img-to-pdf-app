import 'package:flutter_test/flutter_test.dart';
import 'package:img_to_pdf_app/main.dart';

void main() {
  testWidgets('App renders Home Screen with Image to PDF title', (WidgetTester tester) async {
    await tester.pumpWidget(const ImageToPdfApp());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Image to PDF'), findsOneWidget);
    expect(find.text('Your images. One perfect PDF.'), findsOneWidget);
    expect(find.text('Select Images'), findsOneWidget);
  });
}

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:img_to_pdf_app/constants/app_theme.dart';
import 'package:img_to_pdf_app/models/saved_pdf.dart';
import 'package:img_to_pdf_app/screens/home_screen.dart';

void main() {
  testWidgets('Capture Screen 3 Multiple Documents', (tester) async {
    final p1 = SavedPdf(
      id: '1',
      title: 'Business_Contract_Final.pdf',
      filePath: '/storage/Business_Contract_Final.pdf',
      pageCount: 5,
      fileSizeBytes: 2450000,
      createdAt: DateTime.now(),
    );
    final p2 = SavedPdf(
      id: '2',
      title: 'Office_Receipts_Nov.pdf',
      filePath: '/storage/Office_Receipts_Nov.pdf',
      pageCount: 2,
      fileSizeBytes: 890000,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    );
    final p3 = SavedPdf(
      id: '3',
      title: 'Identification_Card_Scan.pdf',
      filePath: '/storage/Identification_Card_Scan.pdf',
      pageCount: 1,
      fileSizeBytes: 420000,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    );
    SharedPreferences.setMockInitialValues({
      'saved_pdf_history_v1': [p1.toJson(), p2.toJson(), p3.toJson()],
    });

    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2.0;

    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: RepaintBoundary(
            key: key,
            child: const SizedBox(
              width: 540,
              height: 960,
              child: HomeScreen(),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final decoded = img.decodeImage(pngBytes)!;
    final resized = img.copyResize(decoded, width: 1080, height: 1920);
    File('play_store_release/graphics/screenshot_3.png').writeAsBytesSync(img.encodePng(resized));
    print('SUCCESS: screenshot_3.png generated from real Flutter widgets!');
  });
}

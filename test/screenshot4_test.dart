import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:img_to_pdf_app/constants/app_theme.dart';
import 'package:img_to_pdf_app/screens/home_screen.dart';

void main() {
  testWidgets('Capture Screen 4 Clean Dashboard', (tester) async {
    SharedPreferences.setMockInitialValues({
      'saved_pdf_history_v1': <String>[],
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
    File('play_store_release/graphics/screenshot_4.png').writeAsBytesSync(img.encodePng(resized));
    print('SUCCESS: screenshot_4.png generated from real Flutter widgets!');
  });
}

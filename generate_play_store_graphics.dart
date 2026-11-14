import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final dir = Directory('play_store_release/graphics');
  if (!dir.existsSync()) dir.createSync(recursive: true);

  // 1. Generate 512x512 App Icon
  generateAppIcon();

  // 2. Generate 1024x500 Feature Graphic
  generateFeatureGraphic();

  // 3. Generate Screenshots (1080x1920)
  generateScreenshot(
    fileName: 'screenshot_1.png',
    title: 'Your Images. One Perfect PDF.',
    subtitle: '100% Free, Private & Offline Conversion',
    tag: 'NO ADS · NO LOGIN · OPEN SOURCE',
  );

  generateScreenshot(
    fileName: 'screenshot_2.png',
    title: 'Easy Page Reorder & 90° Rotation',
    subtitle: 'Organize your document pages with complete ease',
    tag: 'BATCH IMAGE SELECTION & CAMERA',
  );

  generateScreenshot(
    fileName: 'screenshot_3.png',
    title: 'Professional Page Formats & Margins',
    subtitle: 'A4, US Letter, Grayscale & Smart Compression',
    tag: 'CUSTOM PDF PAGE CONTROLS',
  );

  generateScreenshot(
    fileName: 'screenshot_4.png',
    title: 'Offline Document Management',
    subtitle: 'Instant PDF preview, print and one-tap sharing',
    tag: '100% ON-DEVICE SECURITY',
  );

  print('All Google Play store graphics generated successfully!');
}

void generateAppIcon() {
  final image = img.Image(width: 512, height: 512);
  // Pure white background
  img.fill(image, color: img.ColorRgb8(255, 255, 255));

  // Outer rounded border in soft grey
  img.drawRect(
    image,
    x1: 8,
    y1: 8,
    x2: 503,
    y2: 503,
    color: img.ColorRgb8(234, 234, 234),
  );

  // Red document body: #E5322D
  final red = img.ColorRgb8(0xE5, 0x32, 0x2D);
  final darkRed = img.ColorRgb8(0xC7, 0x28, 0x24);
  final white = img.ColorRgb8(255, 255, 255);

  // Main document rectangle
  img.fillRect(
    image,
    x1: 96,
    y1: 64,
    x2: 416,
    y2: 448,
    color: red,
  );

  // Folded top-right triangle / ear
  img.fillRect(
    image,
    x1: 320,
    y1: 64,
    x2: 416,
    y2: 160,
    color: darkRed,
  );

  // Document lines (white)
  for (int y = 240; y <= 380; y += 45) {
    img.fillRect(image, x1: 140, y1: y, x2: 372, y2: y + 16, color: white);
  }

  File('play_store_release/graphics/app_icon_512.png').writeAsBytesSync(img.encodePng(image));
  print('Generated app_icon_512.png');
}

void generateFeatureGraphic() {
  final image = img.Image(width: 1024, height: 500);
  // Crisp light background: #F7F7F7
  img.fill(image, color: img.ColorRgb8(0xF7, 0xF7, 0xF7));

  // Red Accent top banner: #E5322D
  final red = img.ColorRgb8(0xE5, 0x32, 0x2D);
  final darkRed = img.ColorRgb8(0xC7, 0x28, 0x24);
  final white = img.ColorRgb8(255, 255, 255);

  img.fillRect(image, x1: 0, y1: 0, x2: 1024, y2: 12, color: red);

  // Draw Document emblem on left
  img.fillRect(image, x1: 80, y1: 100, x2: 280, y2: 400, color: red);
  img.fillRect(image, x1: 220, y1: 100, x2: 280, y2: 160, color: darkRed);
  for (int y = 220; y <= 340; y += 40) {
    img.fillRect(image, x1: 110, y1: y, x2: 250, y2: y + 14, color: white);
  }

  // Right card container
  img.fillRect(image, x1: 340, y1: 100, x2: 944, y2: 400, color: white);
  img.drawRect(image, x1: 340, y1: 100, x2: 944, y2: 400, color: img.ColorRgb8(0xEA, 0xEA, 0xEA));

  // Accent pill
  img.fillRect(image, x1: 380, y1: 140, x2: 560, y2: 175, color: red);

  File('play_store_release/graphics/feature_graphic_1024x500.png').writeAsBytesSync(img.encodePng(image));
  print('Generated feature_graphic_1024x500.png');
}

void generateScreenshot({
  required String fileName,
  required String title,
  required String subtitle,
  required String tag,
}) {
  final image = img.Image(width: 1080, height: 1920);
  // Pure white background
  img.fill(image, color: img.ColorRgb8(255, 255, 255));

  final red = img.ColorRgb8(0xE5, 0x32, 0x2D);
  final softGrey = img.ColorRgb8(0xF7, 0xF7, 0xF7);
  final border = img.ColorRgb8(0xEA, 0xEA, 0xEA);

  // Red top bar
  img.fillRect(image, x1: 0, y1: 0, x2: 1080, y2: 30, color: red);

  // Header tag pill
  img.fillRect(image, x1: 80, y1: 120, x2: 460, y2: 180, color: red);

  // Phone Mockup Frame inside screenshot
  img.fillRect(image, x1: 90, y1: 380, x2: 990, y2: 1840, color: softGrey);
  img.drawRect(image, x1: 90, y1: 380, x2: 990, y2: 1840, color: border);

  // App Bar Mockup inside frame
  img.fillRect(image, x1: 92, y1: 382, x2: 988, y2: 500, color: img.ColorRgb8(255, 255, 255));
  img.drawRect(image, x1: 92, y1: 382, x2: 988, y2: 500, color: border);

  // Mini logo inside phone
  img.fillRect(image, x1: 130, y1: 415, x2: 190, y2: 480, color: red);

  // Hero Card Mockup
  img.fillRect(image, x1: 130, y1: 540, x2: 950, y2: 1000, color: img.ColorRgb8(255, 255, 255));
  img.drawRect(image, x1: 130, y1: 540, x2: 950, y2: 1000, color: border);

  // Big Red Primary Button
  img.fillRect(image, x1: 180, y1: 850, x2: 900, y2: 940, color: red);

  // Content cards inside phone
  img.fillRect(image, x1: 130, y1: 1050, x2: 520, y2: 1480, color: img.ColorRgb8(255, 255, 255));
  img.drawRect(image, x1: 130, y1: 1050, x2: 520, y2: 1480, color: border);

  img.fillRect(image, x1: 560, y1: 1050, x2: 950, y2: 1480, color: img.ColorRgb8(255, 255, 255));
  img.drawRect(image, x1: 560, y1: 1050, x2: 950, y2: 1480, color: border);

  File('play_store_release/graphics/$fileName').writeAsBytesSync(img.encodePng(image));
  print('Generated $fileName');
}

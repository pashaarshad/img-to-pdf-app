import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:img_to_pdf_app/models/image_item.dart';
import 'package:img_to_pdf_app/models/pdf_config.dart';
import 'package:img_to_pdf_app/services/pdf_generator_service.dart';

void main() {
  test('PdfGeneratorService creates valid PDF bytes offline', () async {
    // Create a 100x100 dummy test image using pure dart image
    final testImage = img.Image(width: 100, height: 100);
    img.fill(testImage, color: img.ColorRgb8(255, 0, 0));
    final testJpg = Uint8List.fromList(img.encodeJpg(testImage));

    final images = [
      ImageItem(
        id: '1',
        name: 'test_1.jpg',
        bytes: testJpg,
        sizeInBytes: testJpg.length,
        rotationDegrees: 90,
      ),
      ImageItem(
        id: '2',
        name: 'test_2.jpg',
        bytes: testJpg,
        sizeInBytes: testJpg.length,
      ),
    ];

    final config = PdfConfig(
      fileName: 'Test_Export',
      pageFormat: PdfPageFormatType.a4,
      orientation: PdfOrientationType.portrait,
      margin: PdfMarginType.small,
      compression: PdfCompressionType.medium,
      isGrayscale: true,
      showPageNumbers: true,
    );

    final pdfBytes = await PdfGeneratorService.generatePdf(
      images: images,
      config: config,
    );

    expect(pdfBytes, isNotNull);
    expect(pdfBytes.isNotEmpty, isTrue);

    // Verify PDF header magic bytes %PDF-
    final header = String.fromCharCodes(pdfBytes.sublist(0, 5));
    expect(header, equals('%PDF-'));
  });
}

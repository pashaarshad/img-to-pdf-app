import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/image_item.dart';
import '../models/pdf_config.dart';

class PdfGeneratorService {
  /// Generates a PDF file locally from a list of images.
  /// Reports progress via optional callback (0.0 to 1.0).
  static Future<Uint8List> generatePdf({
    required List<ImageItem> images,
    required PdfConfig config,
    void Function(double progress, String status)? onProgress,
  }) async {
    final pdf = pw.Document(
      title: config.fileName,
      author: 'AP Programming Tech',
      creator: 'Image to PDF Converter by AP Programming Tech (Open Source)',
    );

    final total = images.length;

    for (int i = 0; i < total; i++) {
      final item = images[i];
      onProgress?.call((i / total) * 0.9, 'Processing page ${i + 1} of $total...');

      // 1. Process image locally (rotation, compression, grayscale)
      final processedBytes = await _processImage(
        rawBytes: item.bytes,
        rotationDegrees: item.rotationDegrees,
        quality: config.compression.quality,
        isGrayscale: config.isGrayscale,
      );

      final pdfImage = pw.MemoryImage(processedBytes);

      // 2. Determine target page dimensions
      PdfPageFormat targetFormat;
      switch (config.pageFormat) {
        case PdfPageFormatType.letter:
          targetFormat = PdfPageFormat.letter;
          break;
        case PdfPageFormatType.legal:
          targetFormat = PdfPageFormat.legal;
          break;
        case PdfPageFormatType.fitImage:
          // Use image aspect ratio directly
          final decoded = img.decodeImage(processedBytes);
          if (decoded != null) {
            targetFormat = PdfPageFormat(
              decoded.width.toDouble(),
              decoded.height.toDouble(),
            );
          } else {
            targetFormat = PdfPageFormat.a4;
          }
          break;
        case PdfPageFormatType.a4:
          targetFormat = PdfPageFormat.a4;
          break;
      }

      // 3. Determine orientation
      if (config.pageFormat != PdfPageFormatType.fitImage) {
        switch (config.orientation) {
          case PdfOrientationType.landscape:
            targetFormat = targetFormat.landscape;
            break;
          case PdfOrientationType.auto:
            final decoded = img.decodeImage(processedBytes);
            if (decoded != null && decoded.width > decoded.height) {
              targetFormat = targetFormat.landscape;
            } else {
              targetFormat = targetFormat.portrait;
            }
            break;
          case PdfOrientationType.portrait:
            targetFormat = targetFormat.portrait;
            break;
        }
      }

      final marginPt = config.margin.value;
      final pageMargin = pw.EdgeInsets.all(marginPt);

      // 4. Add Page to Document
      pdf.addPage(
        pw.Page(
          pageFormat: targetFormat,
          margin: pageMargin,
          build: (pw.Context context) {
            final content = pw.Center(
              child: pw.Image(
                pdfImage,
                fit: pw.BoxFit.contain,
              ),
            );

            if (!config.showPageNumbers) {
              return content;
            }

            return pw.Stack(
              children: [
                content,
                pw.Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: pw.Container(
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.only(top: 8),
                    child: pw.Text(
                      'Page ${context.pageNumber} of ${context.pagesCount}',
                      style: const pw.TextStyle(
                        color: PdfColor.fromInt(0xFF777777),
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    onProgress?.call(0.95, 'Building PDF document...');
    final pdfBytes = await pdf.save();
    onProgress?.call(1.0, 'Completed!');

    return pdfBytes;
  }

  /// Locally transforms image: applies rotation, grayscale, and JPEG re-compression.
  static Future<Uint8List> _processImage({
    required Uint8List rawBytes,
    required int rotationDegrees,
    required int quality,
    required bool isGrayscale,
  }) async {
    // If no transformation and 100% quality requested, return original directly
    if (rotationDegrees == 0 && !isGrayscale && quality >= 100) {
      return rawBytes;
    }

    // Decode with pure-dart image library
    img.Image? decoded = img.decodeImage(rawBytes);
    if (decoded == null) {
      return rawBytes; // fallback to raw
    }

    // Rotation
    if (rotationDegrees != 0) {
      decoded = img.copyRotate(decoded, angle: rotationDegrees);
    }

    // Grayscale
    if (isGrayscale) {
      decoded = img.grayscale(decoded);
    }

    // Encode to JPEG with specified quality
    final encoded = img.encodeJpg(decoded, quality: quality);
    return Uint8List.fromList(encoded);
  }
}

enum PdfPageFormatType {
  a4('A4 (Standard)'),
  letter('US Letter'),
  legal('US Legal'),
  fitImage('Fit to Image');

  final String label;
  const PdfPageFormatType(this.label);
}

enum PdfOrientationType {
  portrait('Portrait'),
  landscape('Landscape'),
  auto('Auto Match');

  final String label;
  const PdfOrientationType(this.label);
}

enum PdfMarginType {
  none('No Margin (0mm)', 0.0),
  small('Small (10mm)', 20.0),
  big('Standard (20mm)', 40.0);

  final String label;
  final double value;
  const PdfMarginType(this.label, this.value);
}

enum PdfCompressionType {
  original('Original (100% Quality)', 100),
  high('High (85% Quality)', 85),
  medium('Medium (65% Quality - Recommended)', 65),
  compact('Compact (45% Quality - Smallest Size)', 45);

  final String label;
  final int quality;
  const PdfCompressionType(this.label, this.quality);
}

class PdfConfig {
  String fileName;
  PdfPageFormatType pageFormat;
  PdfOrientationType orientation;
  PdfMarginType margin;
  PdfCompressionType compression;
  bool isGrayscale;
  bool showPageNumbers;
  String? password;

  PdfConfig({
    required this.fileName,
    this.pageFormat = PdfPageFormatType.a4,
    this.orientation = PdfOrientationType.portrait,
    this.margin = PdfMarginType.small,
    this.compression = PdfCompressionType.medium,
    this.isGrayscale = false,
    this.showPageNumbers = false,
    this.password,
  });

  PdfConfig copyWith({
    String? fileName,
    PdfPageFormatType? pageFormat,
    PdfOrientationType? orientation,
    PdfMarginType? margin,
    PdfCompressionType? compression,
    bool? isGrayscale,
    bool? showPageNumbers,
    String? password,
  }) {
    return PdfConfig(
      fileName: fileName ?? this.fileName,
      pageFormat: pageFormat ?? this.pageFormat,
      orientation: orientation ?? this.orientation,
      margin: margin ?? this.margin,
      compression: compression ?? this.compression,
      isGrayscale: isGrayscale ?? this.isGrayscale,
      showPageNumbers: showPageNumbers ?? this.showPageNumbers,
      password: password ?? this.password,
    );
  }
}

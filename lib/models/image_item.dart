import 'dart:typed_data';

class ImageItem {
  final String id;
  final String name;
  final String? path;
  final Uint8List bytes;
  final int sizeInBytes;
  int rotationDegrees; // 0, 90, 180, 270

  ImageItem({
    required this.id,
    required this.name,
    this.path,
    required this.bytes,
    required this.sizeInBytes,
    this.rotationDegrees = 0,
  });

  void rotateRight() {
    rotationDegrees = (rotationDegrees + 90) % 360;
  }

  void rotateLeft() {
    rotationDegrees = (rotationDegrees - 90 + 360) % 360;
  }

  String get formattedSize {
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

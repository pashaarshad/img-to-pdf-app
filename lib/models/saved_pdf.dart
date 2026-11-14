import 'dart:convert';

class SavedPdf {
  final String id;
  final String title;
  final String filePath;
  final int pageCount;
  final int fileSizeBytes;
  final DateTime createdAt;

  SavedPdf({
    required this.id,
    required this.title,
    required this.filePath,
    required this.pageCount,
    required this.fileSizeBytes,
    required this.createdAt,
  });

  String get formattedSize {
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'filePath': filePath,
      'pageCount': pageCount,
      'fileSizeBytes': fileSizeBytes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SavedPdf.fromMap(Map<String, dynamic> map) {
    return SavedPdf(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      filePath: map['filePath'] ?? '',
      pageCount: map['pageCount'] ?? 1,
      fileSizeBytes: map['fileSizeBytes'] ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());
  factory SavedPdf.fromJson(String source) => SavedPdf.fromMap(json.decode(source));
}
